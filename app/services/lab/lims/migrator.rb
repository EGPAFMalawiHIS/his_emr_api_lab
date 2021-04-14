# frozen_string_literal: true

require 'parallel'
require 'couch_bum/couch_bum'
require 'logger_multiplexor'

require 'concept'
require 'concept_name'
require 'drug_order'
require 'encounter'
require 'encounter_type'
require 'observation'
require 'order'
require 'order_type'
require 'patient'
require 'patient_identifier'
require 'patient_identifier_type'
require 'person'
require 'person_name'
require 'program'
require 'user'

require 'lab/lab_encounter'
require 'lab/lab_order'
require 'lab/lab_result'
require 'lab/lab_test'
require 'lab/lims_order_mapping'
require 'lab/lims_failed_import'

require_relative '../orders_service'
require_relative '../results_service'
require_relative '../../../serializers/lab/lab_order_serializer'
require_relative '../../../serializers/lab/result_serializer'
require_relative '../../../serializers/lab/test_serializer'

require_relative 'order_dto'
require_relative 'utils'

module Lab
  module Lims
    module Migrator
      class MigratorApi < Api
        attr_accessor :last_seq

        MAX_THREADS = 4

        def initialize(*args, **kwargs)
          super(*args, **kwargs)

          initialize_last_seq
          @mutex = Mutex.new
        end

        def consume_orders(from: nil, limit: 5000)
          loop do
            start_key_param = from ? "&skip=#{from}" : ''
            url = "_all_docs?include_docs=true&limit=#{limit}#{start_key_param}"

            Rails.logger.debug("#{MigratorApi}: Pulling orders from LIMS CouchDB: #{url}")
            response = bum.couch_rest :get, url

            from ||= 0

            return from if response['rows'].empty?

            Parallel.map(response['rows'], in_threads: MAX_THREADS) do |row|
              next unless row['doc']['type']&.casecmp?('Order')

              User.current = Migrator.lab_user

              yield OrderDTO.new(row['doc']), OpenStruct.new(last_seq: from)
            end

            from += response['rows'].size
          ensure
            save_last_seq(from)
          end
        end

        def close
          @mutex.synchronize do
            @last_seq_file&.close
            @last_seq_file = nil
          end
        end

        private

        def initialize_last_seq
          last_seq_path = Rails.root.join('log/lims-migration-last-id.dat')
          @last_seq_file = File.new(last_seq_path, File::RDWR | File::CREAT, 0o644)

          stored_last_seq = @last_seq_file&.read&.strip
          @last_seq = stored_last_seq.blank? ? nil : stored_last_seq&.to_i
        end

        def save_last_seq(last_seq)
          return unless last_seq

          @mutex.synchronize do
            @last_seq = last_seq
            @last_seq_file.rewind
            @last_seq_file.write(last_seq.to_s)
          end
        end
      end

      class MigrationWorker < Worker
        protected

        def last_seq
          lims_api.last_seq
        end

        def update_last_seq(_last_seq); end
      end

      def self.lab_user
        user = User.find_by_username('lab_daemon')
        return user if user

        god_user = User.first

        person = Person.create!(creator: god_user.user_id)
        PersonName.create!(person: person, given_name: 'Lab', family_name: 'Daemon', creator: god_user.user_id)

        User.create!(username: 'lab_daemon', person: person, creator: god_user.user_id)
      end

      def self.start_migration
        logger = LoggerMultiplexor.new(Logger.new($stdout), Rails.root.join('log/lims-migration.log'))
        logger.level = :debug
        Rails.logger = logger
        ActiveRecord::Base.logger = logger
        # CouchBum.logger = logger

        api = MigratorApi.new
        worker = MigrationWorker.new(api)

        worker.pull_orders
      ensure
        api&.close
      end
    end
  end
end
