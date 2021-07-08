# frozen_string_literal: true

require 'logger_multiplexor'

module Lab
  module Lims
    LIMS_LOG_PATH = Rails.root.join('log', 'lims')
    FileUtils.mkdir_p(LIMS_LOG_PATH) unless File.exist?(LIMS_LOG_PATH)

    ##
    # Pull/Push orders from/to the LIMS queue (Oops meant CouchDB).
    module Worker
      def self.start
        User.current = Utils.lab_user

        fork(&method(:start_push_worker))
        fork(&method(:start_pull_worker))

        Process.waitall
      end

      def self.start_push_worker
        start_worker('push_worker') do
          api = Lims::Api::RestApi.new(config: Lab::Lims::Config.rest_api)
          worker = PushWorker.new(api)

          worker.push_orders
        end
      end

      def self.start_pull_worker
        start_worker('pull_worker') do
          api = if realtime_updates_enabled?
                  Lims::Api::WsApi.new(Lab::Lims::Config.updates_socket)
                else
                  Lims::Api::RestApi.new(Lab::Lims::Config.rest_api)
                end

          worker = PullWorker.new(api)
          worker.pull_orders
        end
      end

      def self.start_worker(worker_name)
        Rails.logger = LoggerMultiplexor.new(log_path("#{worker_name}.log"), $stdout)
        ActiveRecord::Base.logger = Rails.logger
        Rails.logger.level = :debug

        File.open(log_path("#{worker_name}.lock"), File::RDWR | File::CREAT, 0o644) do |fout|
          unless fout.flock(File::LOCK_EX | File::LOCK_NB)
            Rails.logger.warn("Another process already holds lock #{worker_name} (#{fout.read}), exiting...")
            break
          end

          fout.write("Locked by process ##{Process.ppid} at #{Time.now}")
          yield
        end
      end

      def self.log_path(filename)
        LIMS_LOG_PATH.join(filename)
      end

      def self.realtime_updates_enabled?
        Lims::Config.updates_socket.key?('url')
      rescue Lab::Lims::Config::ConfigNotFound => e
        Rails.logger.warn("Check for realtime updates failed: #{e.message}")
        false
      end
    end
  end
end
