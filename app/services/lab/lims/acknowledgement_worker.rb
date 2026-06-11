# frozen_string_literal: true

module Lab
  module Lims
    # This class is responsible for handling the acknowledgement of lab orders
    class AcknowledgementWorker
      attr_reader :lims_api, :start_date

      include Utils # for logger

      SECONDS_TO_WAIT_FOR_ORDERS = 30

      def initialize(lims_api, start_date: nil)
        @lims_api = lims_api
        @start_date = start_date
      end

      def push_acknowledgement(batch_size: 1000, wait: false)
        loop do
          logger.info('Looking for new acknowledgements to push to LIMS...')
          acknowledgements = Lab::AcknowledgementService.acknowledgements_pending_sync(batch_size,
                                                                                       start_date: start_date).all

          logger.debug("Found #{acknowledgements.size} acknowledgements...")
          acknowledgements.each do |acknowledgement|
            Lab::AcknowledgementService.push_acknowledgement(acknowledgement, @lims_api)
          rescue StandardError => e
            logger.error("Failed to push acknowledgement ##{acknowledgement.order_id}: #{e.class} - #{e.message}")
          end

          # If no records found or not waiting, check if we should continue
          if acknowledgements.empty?
            break unless wait
          elsif !wait && acknowledgements.size < batch_size
            # Processed final partial batch in one-shot mode
            logger.info("Processed final batch of #{acknowledgements.size} acknowledgements")
            break
          elsif !wait
            # More records likely exist, continue processing
            logger.info('Batch complete, checking for more acknowledgements...')
            next
          end

          logger.info('Waiting for acknowledgements...')
          sleep(Lab::Lims::Config.updates_poll_frequency)
        end
      end
    end
  end
end
