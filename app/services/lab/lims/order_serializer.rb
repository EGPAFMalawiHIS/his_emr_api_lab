# frozen_string_literal: true

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
            phone_number: phone_number.value,
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

        def format_test_results(order)
          order.tests.each_with_object({}) do |test, results|
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
      end
    end
  end
end
