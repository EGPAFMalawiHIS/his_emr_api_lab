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
require_relative '../tests_service'
require_relative '../../../serializers/lab/lab_order_serializer'
require_relative '../../../serializers/lab/result_serializer'
require_relative '../../../serializers/lab/test_serializer'

require_relative 'order_dto'
require_relative 'utils'

module Lab
  module Lims
    module Migrator
      class MigratorApi < Api
        MAX_THREADS = 6

        def consume_orders(from: nil, limit: 50_000)
          Parallel.each(read_orders(from, limit),
                        in_processes: MAX_THREADS,
                        finish: ->(_, i, _) { save_last_seq(from + i) }) do |row|
            next unless row['doc']['type']&.casecmp?('Order')

            User.current = Migrator.lab_user

            yield OrderDTO.new(row['doc']), OpenStruct.new(last_seq: from)
          end
        end

        def last_seq
          return 0 unless File.exist?(last_seq_path)

          File.open(last_seq_path, File::RDONLY) do |file|
            last_seq = file.read&.strip
            return last_seq.blank? ? nil : last_seq&.to_i
          end
        end

        private

        def last_seq_path
          Rails.root.join('log/lims-migration-last-id.dat')
        end

        def save_last_seq(last_seq)
          return unless last_seq

          File.open(last_seq_path, File::WRONLY | File::CREAT, 0o644) do |file|
            Rails.logger.debug("Process ##{Parallel.worker_number}: Saving last seq: #{last_seq}")
            file.flock(File::LOCK_EX)
            file.write(last_seq.to_s)
            file.flush
          end
        end

        def read_orders(from, batch_size)
          Enumerator.new do |enum|
            loop do
              start_key_param = from ? "&skip=#{from}" : ''
              url = "_all_docs?include_docs=true&limit=#{batch_size}#{start_key_param}"

              Rails.logger.debug("#{MigratorApi}: Pulling orders from LIMS CouchDB: #{url}")
              response = bum.couch_rest :get, url

              from ||= 0

              break from if response['rows'].empty?

              response['rows'].each do |row|
                enum.yield(row)
              end

              from += response['rows'].size
            end
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
      end
    end
  end
end
