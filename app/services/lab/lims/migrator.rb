# frozen_string_literal: true

require 'couch_bum/couch_bum'
require 'logger_multiplexor'

module Lab
  module Lims
    module Migrator
      class MigratorApi < Api
        def consume_orders(from: nil, limit: 5000)
          start_key_param = from ? "&skip=#{from}" : ''
          url = "_all_docs?include_docs=true&limit=#{limit}#{start_key_param}"

          Rails.logger.debug("#{MigratorApi}: Pulling orders from LIMS CouchDB: #{url}")
          response = bum.couch_rest :get, url

          response['rows'].each_with_index do |row, i|
            next unless row['doc']['type']&.casecmp?('Order')

            yield OrderDTO.new(row['doc']), OpenStruct.new(last_seq: (from || 0) + i)
          end

          (from || 0) + response['rows'].size
        end
      end

      class MigrationWorker < Worker
        attr_reader :last_seq

        def initialize(*args, **kwargs)
          super(*args, **kwargs)

          initialize_last_seq
        end

        def cleanup
          @last_seq_file&.close
          @last_seq_file = nil
        end

        private

        def update_last_seq(last_seq)
          return unless last_seq

          @last_seq = last_seq
          @last_seq_file.rewind
          @last_seq_file.write(last_seq.to_s)
        end

        def initialize_last_seq
          last_seq_path = Rails.root.join('log/lims-migration-last-id.dat')
          @last_seq_file = File.new(last_seq_path, File::RDWR | File::CREAT, 0o644)

          stored_last_seq = @last_seq_file&.read&.strip
          @last_seq = stored_last_seq.blank? ? nil : stored_last_seq&.to_i
        end
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
        CouchBum.logger = logger

        User.current = lab_user

        worker = MigrationWorker.new(MigratorApi.new)
        initial_seq = worker.last_seq

        loop do
          last_seq = worker.pull_orders
          break if last_seq == initial_seq

          initial_seq = last_seq
        end
      ensure
        worker&.cleanup
      end
    end
  end
end
