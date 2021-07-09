# frozen_string_literal: true

module Lab
  module Lims
    class PushWorker
      attr_reader :lims_api

      include Utils # for logger

      SECONDS_TO_WAIT_FOR_ORDERS = 30

      def initialize(lims_api)
        @lims_api = lims_api
      end

      def push_orders(batch_size: 1000, wait: false)
        loop do
          logger.info('Looking for new orders to push to LIMS...')
          orders = orders_pending_sync(batch_size).all
          orders.each { |order| push_order(order) }

          # Doing this after .each above to stop ActiveRecord from executing
          # an extra request to the database (ActiveRecord's lazy evaluation
          # sometimes leads to unnecessary database hits for checking counts).
          if orders.empty? && !wait
            logger.info('Finished processing orders; exiting...')
            break
          end

          sleep(Lab::Lims::Config.updates_poll_frequency)
        end
      end

      def push_order_by_id(order_id)
        order = Lab::LabOrder.unscoped.find(order_id)
        push_order(order)
      end

      ##
      # Pushes given order to LIMS queue
      def push_order(order)
        logger.info("Pushing order ##{order.order_id}")

        order_dto = Lab::Lims::OrderSerializer.serialize_order(order)
        mapping = Lab::LimsOrderMapping.find_by(order_id: order.order_id)

        ActiveRecord::Base.transaction do
          if mapping && !order.voided.zero?
            Rails.logger.info("Deleting order ##{order_dto['accession_number']} from LIMS")
            lims_api.delete_order(mapping.lims_id, order_dto)
            mapping.destroy
          elsif mapping
            Rails.logger.info("Updating order ##{order_dto['accession_number']} in LIMS")
            lims_api.update_order(mapping.lims_id, order_dto)
            mapping.update(pushed_at: Time.now)
          else
            Rails.logger.info("Creating order ##{order_dto['accession_number']} in LIMS")
            update = lims_api.create_order(order_dto)
            Lab::LimsOrderMapping.create!(order: order, lims_id: update['id'], revision: update['rev'], pushed_at: Time.now)
          end
        end

        order_dto
      end

      private

      def orders_pending_sync(batch_size)
        return new_orders.limit(batch_size) if new_orders.exists?

        return voided_orders.limit(batch_size) if voided_orders.exists?

        updated_orders.limit(batch_size)
      end

      def new_orders
        Rails.logger.debug('Looking for new orders that need to be created in LIMS...')
        Lab::LabOrder.where.not(order_id: Lab::LimsOrderMapping.all.select(:order_id))
      end

      def updated_orders
        Rails.logger.debug('Looking for recently updated orders that need to be pushed to LIMS...')
        last_updated = Lab::LimsOrderMapping.select('MAX(updated_at) AS last_updated')
                                            .first
                                            .last_updated

        Lab::LabOrder.left_joins(:results)
                     .where('orders.discontinued_date > :last_updated
                             OR obs.date_created > :last_updated',
                            last_updated: last_updated)
                     .group('orders.order_id')
      end

      def voided_orders
        Rails.logger.debug('Looking for voided orders that are being tracked by LIMS...')
        Lab::LabOrder.unscoped
                     .where(order_type: OrderType.where(name: Lab::Metadata::ORDER_TYPE_NAME),
                            order_id: Lab::LimsOrderMapping.all.select(:order_id),
                            voided: 1)
      end
    end
  end
end
