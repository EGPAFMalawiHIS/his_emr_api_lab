# frozen_string_literal: true

module Lab
  module Lims
    ##
    # Pull/Push orders from/to the LIMS queue (Oops meant CouchDB).
    module Worker
      class << self
        include Utils

        ##
        # Pushes given order to LIMS queue
        def push_order(order_id)
          lims_order = limsify_order(LabOrder.find(order_id))
          mapping = LimsOrderMapping.find_by(order_id: order_id)

          if mapping
            lims_api.update_order(mapping.lims_id, lims_order)
            mapping.update(pushed_at: Time.now)
          else
            lims_order = lims_api.create_order(lims_order)
            LimsOrderMapping.create(order: order, lims_id: lims_order._id, pushed_at: Time.now)
          end

          lims_order
        end

        ##
        # Pulls orders from the LIMS queue and writes them to the local database
        def pull_orders
          lims_api.consume_orders(from: last_seq) do |order, context|
            logger.debug(`Retrieved order ##{order.tracking_number}`)

            patient = find_patient(order.patient.id)

            unless patient
              logger.debug(`Non local patient ##{order.patient_id} on order ##{order.tracking_number}... Discarding order`)
              break
            end

            save_order(patient, order)
            update_last_seq(context.last_seq)
          end
        end

        private

        def find_patient(nhid)
          national_id_type = PatientIdentifierType.where(name: 'National id')
          identifier = PatientIdentifier.where(type: national_id_type, identifier: nhid)
          patients = Patient.joins(:identifiers).merge(identifier).group(:patient_id).all

          raise "Duplicate National Health ID: #{nhid}" if patients.size > 1

          patients.first
        end

        ##
        # Convert a LabOrder to a LIMS Data Transfer Object
        def limsify_order(order)
          serialized_order = strictify(Lab::LabOrderSerializer.serialized_order(order))

          {
            tracking_number: serialized_order.tracking_number,
            sending_facility: facility_name,
            receiving_facility: serialized_order.target_lab.name,
            patient: format_patient(serialized_order.patient_id),
            order_location: format_order_location(serialized_order.encounter_id),
            sample_type: serialized_order.specimen_type.name,
            districy: district, # yes districy [sic]...
            priority: serialized_order.reason_for_test.name,
            date_created: serialized_order.date_created
          }
        end

        def save_order(patient, lims_order)
          mapping = LimsOrderMapping.find_by(couch_id: lims_order._id)

          if mapping
            update_order(patient, mapping.order_id, lims_order)
            mapping.update(pulled_at: Time.now)
          else
            order = create_order(patient, lims_order)
            LimsOrderMapping.create!(lims_id: lims_order._id, order: order, pulled_at: Time.now)
          end

          order
        end

        def create_order(patient, lims_order)
          order = OrdersService.order_test(patient, unpack_order(lims_order))
          update_results(order, lims_order.test_results)

          order
        end

        def update_order(_patient, order_id, lims_order)
          order = OrdersService.update_order(order_id, unpack_order(lims_order))
          update_results(order, lims_order.test_results)

          order
        end

        def update_results(_order, _lims_results)
          # TODO: Implement me
          raise 'Not implemented error'
        end

        # Unpacks a LIMS order into an object that OrdersService can handle
        def unpack_order(lims_order)
          ActiveSupport::HashWithIndifferentAccess.new(
            program_id: lab_program.program_id,
            patient_id: patient.patient_id,
            specimen_type: { concept_id: specimen_type_id(lims_order.sample_type) },
            tests: lims_order.tests&.map { |test| { concept_id: test_type_id(test) } },
            requesting_clinician: requesting_clinician(lims_order.who_order_test),
            start_date: start_date(lims_order.date_created),
            target_lab: facility_name(lims_order.receiving_facility),
            order_location: facility_name(lims_order.sending_facility),
            reason_for_test: reason_for_test(lims_order.sample_priority)
          )
        end

        # Translates a LIMS specimen name to an OpenMRS concept_id
        def specimen_type_id(lims_specimen_name)
          if lims_specimen_name == 'specimen_not_collected'
            return ConceptName.select(:concept_id).find_by_name!('Unknown')
          end

          concept = ConceptName.select(:concept_id).find_by_name(lims_specimen_name)
          return concept.concept_id if concept

          raise "Unknown specimen name: #{lims_specimen_name}"
        end

        # Translates a LIMS test type name to an OpenMRS concept_id
        def test_type_id(lims_test_name)
          concept = ConceptName.select(:concept_id).find_by_name(lims_test_name)
          return concept.concept_id if concept

          raise "Unknown test type: #{lims_test_name}"
        end

        # Extract requesting clinician name from LIMS
        def requesting_clinician(lims_user)
          # TODO: Extend requesting clinician to an obs tree having extra parameters
          # like phone number and ID to closely match the lims user.
          first_name = lims_user.first_name || ''
          last_name = lims_user.last_name || ''

          if first_name.blank? && last_name.blank?
            logger.warn('Missing requesting clinician name')
            return ''
          end

          "#{first_name} #{last_name}"
        end

        def start_date(lims_order_date_created)
          lims_order_date_created.to_datetime
        end

        # Parses a LIMS facility name
        def facility_name(lims_target_lab)
          return 'Unknown' if lims_target_lab == 'not_assigned'

          lims_target_lab
        end

        # Translates a LIMS priority to a concept_id
        def reason_for_test(lims_sample_priority)
          ConceptName.find_by_name!(lims_sample_priority).concept_id
        end
      end
    end
  end
end
