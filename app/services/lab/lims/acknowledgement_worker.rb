# frozen_string_literal: true

module Lab
  module Lims
    # This class is responsible for handling the acknowledgement of lab orders
    class AcknowledgementWorker
      attr_reader :lims_api

      include Utils # for logger

      SECONDS_TO_WAIT_FOR_ORDERS = 30

      def initialize(lims_api)
        @lims_api = lims_api
      end

      def push_acknowledgement(batch_size: 1000, wait: false)
        loop do
          logger.info('Looking for new acknowledgements to push to LIMS...')
          acknowledgements = acknowledgements_pending_sync(batch_size).all

          logger.debug("Found #{acknowledgements.size} acknowledgements...")
          acknowledgements.each do |acknowledgement|
            push_acknowledgement(acknowledgement)
          rescue GatewayError => e
            logger.error("Failed to push acknowledgement ##{acknowledgement.accession_number}: #{e.class} - #{e.message}")
          end

          break unless wait

          logger.info('Waiting for acknowledgements...')
          sleep(Lab::Lims::Config.updates_poll_frequency)
        end
      end

      private

      def acknowledgements_pending_sync(batch_size)
        Lab::LabAcknowledgement.where(lab_acknowledgement_statuses: { pushed: false })
                               .limit(batch_size)
      end

      def push_acknowledgement(acknowledgement)
        logger.info("Pushing acknowledgement ##{acknowledgement.order_id}")

        acknowledgement_dto = Lab::Lims::AcknowledgementSerializer.serialize_acknowledgement(acknowledgement)
        mapping = Lab::LimsOrderMapping.find_by(order_id: acknowledgement.order_id)

        ActiveRecord::Base.transaction do
          if mapping
            Rails.logger.info("Updating acknowledgement ##{acknowledgement_dto[:tracking_number]} in LIMS")
            response = lims_api.acknowledge(mapping.lims_id, acknowledgement_dto)
            if response['status'] == 200 || response['message'] == 'results already delivered for test name given'
              acknowledgement.pushed = true
              acknowledgement.date_pushed = Time.now
              acknowledgement.save!
            else
              Rails.logger.error("Failed to process acknowledgement for tracking number ##{acknowledgement_dto[:tracking_number]} in LIMS")
            end
          else
            Rails.logger.info("No mapping found for acknowledgement ##{acknowledgement_dto[:tracking_number]}")
          end
        end
      end
    end
  end
end
