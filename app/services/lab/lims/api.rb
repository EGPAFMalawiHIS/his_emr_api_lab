# frozen_string_literal: true

require 'couch_bum/couch_bum'

module Lab
  module Lims
    ##
    # Talk to LIMS like a boss
    class Api
      attr_reader :bum

      def initialize(lims_config)
        @bum = CouchBum.new(lims_config || self.lims_config)
      end

      ##
      # Consume orders from the LIMS queue.
      #
      # Retrieves orders from the LIMS queue and passes each order to
      # given block until the queue is empty or connection is terminated
      # by calling method +choke+.
      def consume_orders(from: 0, limit: 30)
        bum.binge_changes(since: from, limit: limit, include_docs: true) do |change|
          yield OrderDTO.new(change['doc']), self
        end
      end

      def create_order(order)
        bum.couch_rest :post, '/', order
      end

      def update_order(id, order)
        bum.couch_rest :put, "/#{id}", order
      end

      private

      def lims_config
        return @lims_config if @lims_config

        @lims_config ||= YAML.load_file(lims_config_path)[Rails.env]
      end

      def lims_config_path
        paths = [
          "#{ENV['HOME']}/apps/nlims_controller/config/couch.yml",
          Rails.root.parent.join('nlims_controller/config/couch.yml'),
          Rails.root.join('config/lims-couch.yml')
        ]

        paths.each do |path|
          return path if File.exist?(path)
        end

        raise "Could not find a configuration file, checked: #{path}"
      end
    end
  end
end
