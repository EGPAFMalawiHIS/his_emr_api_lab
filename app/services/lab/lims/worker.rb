# frozen_string_literal: true

require_relative './utils'

module Lab
  module Lims
    ##
    # Pull/Push orders from/to the LIMS queue (Oops meant CouchDB).
    class Worker
      include Utils

      attr_reader :lims_api

      def initialize(lims_api)
        @lims_api = lims_api
      end

      ##
      # Pushes given order to LIMS queue
      def push_order(order_id)
        order = LabOrder.find(order_id)
        order_dto = OrderDTO.from_order(order)
        mapping = LimsOrderMapping.find_by(order_id: order_id)

        if mapping
          lims_api.update_order(mapping.lims_id, order_dto)
          mapping.update(pushed_at: Time.now)
        else
          order_dto = lims_api.create_order(order_dto)
          LimsOrderMapping.create(order: order, lims_id: order_dto[:_id], pushed_at: Time.now)
        end

        order_dto
      end

      ##
      # Pulls orders from the LIMS queue and writes them to the local database
      def pull_orders
        lims_api.consume_orders(from: last_seq) do |order_dto, context|
          logger.debug(`Retrieved order ##{order[:tracking_number]}`)

          patient = find_patient_by_nhid(order_dto[:patient][:id])

          unless patient
            logger.debug(`Discarding order: Non local patient ##{order_dto[:patient][:id]} on order ##{order[:tracking_number]}`)
            break
          end

          save_order(patient, order_dto)
          update_last_seq(context.last_seq)
        end
      end

      private

      def find_patient_by_nhid(nhid)
        national_id_type = PatientIdentifierType.where(name: 'National id')
        identifier = PatientIdentifier.where(type: national_id_type, identifier: nhid)
        patients = Patient.joins(:identifiers).merge(identifier).group(:patient_id).all

        raise "Duplicate National Health ID: #{nhid}" if patients.size > 1

        patients.first
      end

      def save_order(patient, order_dto)
        mapping = LimsOrderMapping.find_by(couch_id: order_dto[:_id])

        if mapping
          update_order(patient, mapping.order_id, order_dto)
          mapping.update(pulled_at: Time.now)
        else
          order = create_order(patient, order_dto)
          LimsOrderMapping.create!(lims_id: order_dto[:_id], order: order, pulled_at: Time.now)
        end

        order
      end

      def create_order(patient, order_dto)
        order = OrdersService.order_test(patient, order_dto.to_order_service_params)
        update_results(order, order_dto.test_results)

        order
      end

      def update_order(_patient, order_id, order_dto)
        order = OrdersService.update_order(order_id, order_dto.to_order_service_params)
        update_results(order, order_dto.test_results)

        order
      end

      def update_results(_order, _lims_results)
        # TODO: Implement me
        raise 'Not implemented error'
      end
    end
  end
end
