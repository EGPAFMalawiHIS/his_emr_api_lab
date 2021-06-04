# frozen_string_literal: true

require_relative './order_dto'
require_relative './utils'

module Lab
  module Lims
    ##
    # Serializes a LabOrder into a LIMS OrderDTO.
    module OrderSerializer
      class << self
        include Utils

        def serialize_order(order)
          serialized_order = Utils.structify(Lab::LabOrderSerializer.serialize_order(order))

          OrderDTO.new(
            tracking_number: serialized_order.accession_number,
            sending_facility: current_facility_name,
            receiving_facility: serialized_order.target_lab,
            tests: serialized_order.tests.collect(&:name),
            patient: format_patient(serialized_order.patient_id),
            order_location: format_order_location(serialized_order.encounter_id),
            sample_type: format_sample_type(serialized_order.specimen.name),
            sample_status: format_sample_status(serialized_order.specimen.name),
            sample_statuses: format_sample_status_trail(order),
            test_statuses: format_test_status_trail(order),
            who_order_test: format_orderer(order),
            districy: current_district, # yes districy [sic]...
            priority: serialized_order.reason_for_test.name,
            date_created: serialized_order.order_date,
            test_results: format_test_results(serialized_order),
            type: 'Order'
          )
        end

        private

        def format_order_location(encounter_id)
          location_id = Encounter.select(:location_id).where(encounter_id: encounter_id)
          location = Location.select(:name)
                             .where(location_id: location_id)
                             .first

          location&.name
        end

        # Format patient into a structure that LIMS expects
        def format_patient(patient_id)
          person = Person.find(patient_id)
          name = PersonName.find_by_person_id(patient_id)
          national_id = PatientIdentifier.joins(:type)
                                         .merge(PatientIdentifierType.where(name: 'National ID'))
                                         .where(patient_id: patient_id)
                                         .first
          phone_number = PersonAttribute.joins(:type)
                                        .merge(PersonAttributeType.where(name: 'Cell phone Number'))
                                        .where(person_id: patient_id)
                                        .first

          {
            first_name: name&.given_name,
            last_name: name&.family_name,
            id: national_id&.identifier,
            phone_number: phone_number&.value,
            gender: person.gender,
            email: nil
          }
        end

        def format_sample_type(name)
          name.casecmp?('Unknown') ? 'not_specified' : name
        end

        def format_sample_status(name)
          name.casecmp?('Unknown') ? 'specimen_not_collected' : 'specimen_collected'
        end

        def format_sample_status_trail(order)
          return [] if order.concept_id == ConceptName.find_by_name!('Unknown').concept_id

          user = User.find(order.discontinued_by || order.creator)
          drawn_by = PersonName.find_by_person_id(user.user_id)
          drawn_date = order.discontinued_date || order.start_date

          [
            drawn_date.strftime('%Y%m%d%H%M%S') => {
              'status' => 'Drawn',
              'updated_by' => {
                'first_name' => drawn_by&.given_name || user.username,
                'last_name' => drawn_by&.family_name,
                'phone_number' => nil,
                'id' => user.username
              }
            }
          ]
        end

        def format_test_status_trail(order)
          order.tests.each_with_object({}) do |test, trail|
            test_name = ConceptName.find_by_concept_id!(test.value_coded).name
            test_name = 'Viral load' if test_name.casecmp?('HIV Viral Load')

            current_test_trail = trail[test_name] = {}

            current_test_trail[test.obs_datetime.strftime('%Y%m%d%H%M%S')] = {
              status: 'Drawn',
              updated_by: find_user(test.creator)
            }

            next unless test.result

            current_test_trail[test.obs_datetime.strftime('%Y%m%d%H%M%S')] = {
              status: 'Verified',
              updated_by: find_user(test.result.creator)
            }
          end
        end

        def format_orderer(order)
          find_user(order.creator)
        end

        def format_test_results(order)
          order.tests&.each_with_object({}) do |test, results|
            next unless test.result

            results[test.name] = {
              results: test.result.each_with_object({}) do |measure, measures|
                measures[measure.indicator.name] = { result_value: "#{measure.value_modifier}#{measure.value}" }
              end,
              result_date: test.result.first&.date,
              result_entered_by: {}
            }
          end
        end

        def current_health_center
          health_center = Location.current_health_center
          raise 'Current health center not set' unless health_center

          health_center
        end

        def current_district
          district = current_health_center.city_village\
                       || current_health_center.parent&.name\
                       || GlobalProperty.find_by_property('current_health_center_district')&.property_value

          return district if district

          GlobalProperty.create(property: 'current_health_center_district',
                                property_value: Config.application['district'],
                                uuid: SecureRandom.uuid)

          Config.application['district']
        end

        def current_facility_name
          current_health_center.name
        end

        def find_user(user_id)
          user = User.find(user_id)
          person_name = PersonName.find_by(person_id: user.person_id)
          phone_number = PersonAttribute.find_by(type: PersonAttributeType.where(name: 'Cell phone number'),
                                                 person_id: user.person_id)

          {
            first_name: person_name&.given_name,
            last_name: person_name&.family_name,
            phone_number: phone_number&.value,
            id: user.username
          }
        end
      end
    end
  end
end
