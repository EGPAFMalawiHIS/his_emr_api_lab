# frozen_string_literal: true

require 'cgi/util'

require_relative './api/couchdb_api'
require_relative './exceptions'
require_relative './order_serializer'
require_relative './utils'

module Lab
  module Lims
    LIMS_LOG_PATH = Rails.root.join('log/lims')
    Dir.mkdir(LIMS_LOG_PATH) unless File.exist?(LIMS_LOG_PATH)

    ##
    # Pull/Push orders from/to the LIMS queue (Oops meant CouchDB).
    class Worker
      include Utils

      attr_reader :lims_api

      def self.start
        # TODO: Fork two processes, one for the pull worker and the other
        # for the push worker.
        File.open(LIMS_LOG_PATH.join('worker.lock'), File::WRONLY | File::CREAT, 0o644) do |fout|
          fout.flock(File::LOCK_EX)

          User.current = Utils.lab_user

          fout.write("Worker ##{Process.pid} started at #{Time.now}")
          worker = Worker.new(Api::RestApi.new)
          worker.pull_orders
          worker.push_orders
        end
      end

      def initialize(lims_api)
        @lims_api = lims_api
      end
    end
  end
end
