# frozen_string_literal: true

require_relative './utils'

module Lab
  module Lims
    ##
    # Pull/Push orders from/to the LIMS queue (Oops meant CouchDB).
    class Worker
      def initialize(lims_api)
        @lims_api = lims_api
      end

      include Utils

      attr_reader :lims_api

      def push_orders(batch_size: 100)
        loop do
          logger.info('Fetching new orders...')
          orders = LabOrder.where.not(order_id: LimsOrderMapping.all.select(:order_id))
                           .limit(batch_size)

          if orders.empty?
            logger.info('No new orders available; exiting...')
            break
          end

          orders.each { |order| push_order(order) }
        end
      end

      def push_order_by_id(order_id)
        order = LabOrder.find(order_id)
        push_order(order)
      end

      ##
      # Pushes given order to LIMS queue
      def push_order(order)
        logger.info("Pushing order ##{order.order_id}")

        order_dto = OrderDTO.from_order(order)
        mapping = LimsOrderMapping.find_by(order_id: order.order_id)

        ActiveRecord::Base.transaction do
          if mapping
            lims_api.update_order(mapping.lims_id, order_dto)
            mapping.update(pushed_at: Time.now)
          else
            order_dto = lims_api.create_order(order_dto)
            LimsOrderMapping.create!(order: order, lims_id: order_dto['_id'], pushed_at: Time.now)
          end
        end

        order_dto
      end

      ##
      # Pulls orders from the LIMS queue and writes them to the local database
      def pull_orders
        logger.debug("Retrieving LIMS orders starting from #{last_seq}")
        last_seq = lims_api.consume_orders(from: self.last_seq) do |order_dto, context|
          logger.debug("Retrieved order ##{order_dto[:tracking_number]}: #{order_dto}")
          patient = find_patient_by_nhid(order_dto[:patient][:id])

          unless patient
            logger.debug("Discarding order: Non local patient ##{order_dto[:patient][:id]} on order ##{order_dto[:tracking_number]}")
            update_last_seq(context.last_seq)
            break
          end

          diff = match_patients(patient, order_dto['patient'])
          if diff
            save_conflict(diff)
          else
            save_order(patient, order_dto)
          end

          update_last_seq(context.last_seq)
        end

        update_last_seq(last_seq)
        last_seq
      end

      private

      def find_patient_by_nhid(nhid)
        national_id_type = PatientIdentifierType.where(name: 'National id')
        identifier = PatientIdentifier.where(type: national_id_type, identifier: nhid)
        patients = Patient.joins(:patient_identifiers)
                          .merge(identifier)
                          .distinct(:patient_id)
                          .all

        raise "Duplicate National Health ID: #{nhid}" if patients.size > 1

        patients.first
      end

      ##
      # Matches a local patient to a LIMS patient
      def match_patients(local_patient, lims_patient)
        person = Person.find!(local_patient.id)
        person_name = PersonName.find_by_person_id(local_patient.id)

        diff = {}
        unless person.gender&.first&.casecmp?(lims_patient['gender']&.first)
          diff[:gender] = { local: person.gender, lims: lims_patient['gender'] }
        end

        unless person_name&.given_name&.casecmp?(lims_patient['first_name'])
          diff[:given_name] = { local: person_name&.given_name, lims: lims_patient['first_name'] }
        end

        unless person_name&.family_name&.casecmp?(lims_patient['last_name'])
          diff[:family_name] = { local: person_name&.given_name, lims: lims_patient['last_name'] }
        end

        diff
      end

      def save_order(patient, order_dto)
        mapping = LimsOrderMapping.find_by(lims_id: order_dto[:_id])

        ActiveRecord::Base.transaction do
          if mapping
            order = update_order(patient, mapping.order_id, order_dto)
            mapping.update(pulled_at: Time.now)
          else
            order = create_order(patient, order_dto)
            LimsOrderMapping.create!(lims_id: order_dto[:_id],
                                     order_id: order['id'],
                                     pulled_at: Time.now,
                                     revision: order_dto['_rev'])
          end

          order
        end
      end

      def create_order(patient, order_dto)
        logger.debug("Creating order ##{order_dto['_id']}")
        order = OrdersService.order_test(order_dto.to_order_service_params(patient_id: patient.patient_id))
        update_results(order, order_dto['test_results'])

        order
      end

      def update_order(patient, order_id, order_dto)
        logger.debug("Updating order ##{order_dto['_id']}")
        order = OrdersService.update_order(order_id, order_dto.to_order_service_params(patient_id: patient.patient_id)
                                                              .merge(force_update: true))
        update_results(order, order_dto['test_results'])

        order
      end

      def update_results(order, lims_results)
        return if lims_results.empty?

        lims_results.each do |test_name, test_results|
          test = find_test(order['id'], test_name)
          unless test
            logger.warn("Couldn't find test, #{test_name}, in order ##{order[:id]}")
            next
          end

          measures = test_results['results'].map do |indicator, value|
            measure = find_measure(order, indicator, value)
            next nil unless measure

            measure
          end

          ResultsService.create_results(test.id, provider_id: User.current.person_id,
                                                 date: test_results['date_result_entered'],
                                                 measures: measures)
        end
      end

      def find_test(order_id, test_name)
        test_type = ConceptName.where(name: Metadata::TEST_TYPE_CONCEPT_NAME).select(:concept_id)
        test_concept = ConceptName.where(name: test_name).select(:concept_id)

        LabTest.find_by(order_id: order_id, concept_id: test_type, value_coded: test_concept)
      end

      def find_measure(_order, indicator_name, value)
        indicator = ConceptName.find_by_name(indicator_name)
        unless indicator
          logger.warn("Result indicator #{indicator_name} not found in concepts list")
          return nil
        end

        value_modifier, value, value_type = parse_lims_result_value(value)
        ActiveSupport::HashWithIndifferentAccess.new(
          indicator: { concept_id: indicator.concept_id },
          value_type: value_type,
          value: value,
          value_modifier: value_modifier
        )
      end

      def parse_lims_result_value(value)
        value = value['result_value']

        match = value&.match(/^(>|=|<|<=|>=)(.*)$/)
        return nil, value, 'text' unless match

        if match[2].match?(/^\d+(\.\d+)?$/)
          [match[1], match[2], 'numeric']
        else
          [match[1], match[2], 'text']
        end
      end

      def last_seq
        nil
      end
    end
  end
end
