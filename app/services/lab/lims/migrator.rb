# frozen_string_literal: true

require 'csv'
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

require_relative './worker'
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

        attr_reader :rejections

        def consume_orders(from: nil, **_kwargs)
          limit = 50_000

          Parallel.each(read_orders(from, limit),
                        in_processes: MAX_THREADS,
                        finish: order_pmap_post_processor(from)) do |row|
            next unless row['doc']['type']&.casecmp?('Order')

            User.current = Utils.lab_user
            yield OrderDTO.new(row['doc']), OpenStruct.new(last_seq: (from || 0) + limit, current_seq: from)
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
          LIMS_LOG_PATH.join('migration-last-id.dat')
        end

        def order_pmap_post_processor(last_seq)
          lambda do |item, index, result|
            save_last_seq(last_seq + index)
            status, reason = result
            next unless status == :rejected

            (@rejections ||= []) << OpenStruct.new(order: OrderDTO.new(item['doc']), reason: reason)
          end
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

        def save_rejection(order_dto, reason); end

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

      def self.save_csv(filename, rows:, headers: nil)
        CSV.open(filename, File::WRONLY | File::CREAT) do |csv|
          csv << headers if headers
          rows.each { |row| csv << row }
        end
      end

      MIGRATION_REJECTIONS_CSV_PATH = LIMS_LOG_PATH.join('migration-rejections.csv')

      def self.export_rejections(rejections)
        headers = ['doc_id', 'Accession number', 'NHID', 'First name', 'Last name', 'Reason']
        rows = (rejections || []).map do |rejection|
          [
            rejection.order[:_id],
            rejection.order[:tracking_number],
            rejection.order[:patient][:id],
            rejection.order[:patient][:first_name],
            rejection.order[:patient][:last_name],
            rejection.reason
          ]
        end

        save_csv(MIGRATION_REJECTIONS_CSV_PATH, headers: headers, rows: rows)
      end

      MIGRATION_FAILURES_CSV_PATH = LIMS_LOG_PATH.join('migration-failures.csv')

      def self.export_failures
        headers = ['doc_id', 'Accession number', 'NHID', 'Reason', 'Difference']
        rows = Lab::LimsFailedImport.all.map do |failure|
          [
            failure.lims_id,
            failure.tracking_number,
            failure.patient_nhid,
            failure.reason,
            failure.diff
          ]
        end

        save_csv(MIGRATION_FAILURES_CSV_PATH, headers: headers, rows: rows)
      end

      MIGRATION_LOG_PATH = LIMS_LOG_PATH.join('migration.log')

      def self.start_migration
        log_dir = Rails.root.join('log/lims')
        Dir.mkdir(log_dir) unless File.exist?(log_dir)

        logger = LoggerMultiplexor.new(Logger.new($stdout), MIGRATION_LOG_PATH)
        logger.level = :debug
        Rails.logger = logger
        ActiveRecord::Base.logger = logger
        # CouchBum.logger = logger

        api = MigratorApi.new
        worker = MigrationWorker.new(api)

        worker.pull_orders
      ensure
        api && export_rejections(api.rejections)
        export_failures
      end
    end
  end
end
