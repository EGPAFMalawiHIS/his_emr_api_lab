# frozen_string_literal: true

require_relative 'config'
require_relative 'order_dto'
require_relative 'utils'

module Lab
  module Lims
    ##
    # Serializes a LabOrder into a LIMS OrderDto.
    module OrderSerializer
      class << self
        include Utils

        def serialize_order(order)
          serialized_order = Lims::Utils.structify(Lab::LabOrderSerializer.serialize_order(order))
          Lims::OrderDto.new(
            _id: Lab::LimsOrderMapping.find_by(order: order)&.lims_id || serialized_order.accession_number,
            tracking_number: serialized_order.accession_number,
            sending_facility: current_facility_name(order),
            receiving_facility: serialized_order.target_lab,
            tests: serialized_order.tests.map { |test| format_test_name(test.name) },
            tests_map: serialized_order.tests,
            patient: format_patient(serialized_order.patient_id),
            order_location: format_order_location(serialized_order.encounter_id),
            sample_type: format_sample_type(serialized_order.specimen.name),
            sample_type_map: {
              name: format_sample_type(serialized_order.specimen.name),
              nlims_code: Concept.find(serialized_order.specimen.concept_id).nlims_code
            },
            sample_status: format_sample_status(serialized_order.specimen.name),
            sample_statuses: format_sample_status_trail(order),
            test_statuses: format_test_status_trail(order),
            who_order_test: format_orderer(order),
            districy: current_district(order), # yes districy [sic]...
            priority: format_sample_priority(serialized_order.reason_for_test.name),
            date_created: serialized_order.order_date,
            test_results: format_test_results(serialized_order),
            type: 'Order',
            clinical_history: serialized_order.comment_to_fulfiller
          )
        end

        private

        def format_order_location(encounter_id)
          location_id = Encounter.select(:location_id).where(encounter_id:)
          location = Location.select(:name)
                             .where(location_id:)
                             .first

          location&.name
        end

        # Format patient into a structure that LIMS expects
        def format_patient(patient_id)
          person = Person.find(patient_id)
          name = PersonName.find_by_person_id(patient_id)
          national_id = PatientIdentifier.joins(:type)
                                         .merge(PatientIdentifierType.where(name: 'National ID'))
                                         .where(patient_id:)
                                         .first
          phone_number = PersonAttribute.joins(:type)
                                        .merge(PersonAttributeType.where(name: 'Cell phone Number'))
                                        .where(person_id: patient_id)
                                        .first

          {
            first_name: name&.given_name,
            last_name: name&.family_name,
            id: national_id&.identifier,
            arv_number: find_arv_number(patient_id),
            art_regimen: find_current_regimen(patient_id),
            art_start_date: find_art_start_date(patient_id),
            dob: person.birthdate,
            phone_number: phone_number&.value || 'Unknown',
            gender: person.gender,
            email: nil
          }
        end

        def find_current_regimen(patient_id)
          regimen_data = ActiveRecord::Base.connection.select_one <<~SQL
            SELECT patient_current_regimen(#{patient_id}, current_date()) regimen
          SQL
          return nil if regimen_data.blank?

          regimen_data['regimen']
        rescue StandardError
          nil
        end

        def find_arv_number(patient_id)
          PatientIdentifier.joins(:type)
                           .merge(PatientIdentifierType.where(name: 'ARV Number'))
                           .where(patient_id:)
                           .first&.identifier
        end

        def find_art_start_date(patient_id)
          start_date = ActiveRecord::Base.connection.select_one <<~SQL
            SELECT date_antiretrovirals_started(#{patient_id}, current_date()) AS earliest_date
          SQL
          return nil if start_date.blank?

          start_date['earliest_date']
        rescue StandardError
          nil
        end

        def format_sample_type(name)
          return 'not_specified' if name.casecmp?('Unknown')

          return 'CSF' if name.casecmp?('Cerebrospinal Fluid')

          name.titleize
        end

        def format_sample_status(name)
          name.casecmp?('Unknown') ? 'specimen_not_collected' : 'specimen_collected'
        end

        def format_sample_status_trail(order)
          return [] if order.concept_id == ConceptName.find_by_name!('Unknown').concept_id

          user = User.find(order.creator)
          user = User.find(order.discontinued_by) if Order.columns_hash.key?('discontinued_by') && user.blank?

          drawn_by = PersonName.find_by_person_id(user.user_id)
          drawn_date = order.discontinued_date || order.start_date if %w[discontinued_date start_date].all? do |column|
            order.respond_to?(column)
          end
          drawn_date ||= order.date_created

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
          tests = [0, false].include?(order.voided) ? order.tests : Lab::LabOrderSerializer.voided_tests(order)
          tests.each_with_object({}) do |test, trail|
            test_name = format_test_name(::Concept.find(test.value_coded).test_catalogue_name)

            current_test_trail = trail[test_name] = {}

            current_test_trail[test.obs_datetime.strftime('%Y%m%d%H%M%S')] = {
              status: 'Drawn',
              updated_by: find_user(test.creator)
            }

            unless [0, false].include?(test.voided)
              current_test_trail[test.date_voided.strftime('%Y%m%d%H%M%S')] = {
                status: 'Voided',
                updated_by: find_user(test.voided_by)
              }
            end

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
            next if test.result.nil? || test.result.empty?

            result_obs = Observation.find_by(obs_id: test.result.first.id)
            unless result_obs
              Rails.logger.warn("Observation with obs_id=#{test.result.first.id} not found for test #{test.name} in order #{order.accession_number}")
              next
            end

            test_creator = User.find(result_obs.creator)
            test_creator_name = PersonName.find_by_person_id(test_creator.person_id)

            results[format_test_name(test.name)] = {
              results: test.result.each_with_object({}) do |measure, measures|
                measures[format_test_name(measure.indicator.name)] = {
                  result_value: "#{measure.value_modifier}#{measure.value}"
                }
              end,
              result_date: test.result.first&.date,
              result_entered_by: {
                first_name: test_creator_name&.given_name,
                last_name: test_creator_name&.family_name,
                id: test_creator.username
              }
            }
          rescue ActiveRecord::RecordNotFound => e
            Rails.logger.error("Failed to format test results for test #{test.name} in order #{order.accession_number}: #{e.message}")
            next
          end
        end

        def format_test_name(test_name)
          test_name
        end

        def format_sample_priority(priority)
          return 'Routine' if priority&.casecmp?('Medical examination, routine')

          priority&.titleize
        end

        def current_health_center(order)
          # Get location from order creator (every creator is tied to a location)
          creator = User.unscoped.find_by(user_id: order.creator)
          health_center = creator&.location

          # Fallback to Location.current if creator doesn't have a location
          health_center ||= Location.current

          # Fallback to GlobalProperty if Location.current is not set
          health_center ||= Location.current_health_center

          raise 'Health center not found for order creator and Location.current not set' unless health_center

          health_center
        end

        def current_district(order)
          health_center = current_health_center(order)
          district = health_center.city_village \
                       || health_center.parent&.name \
                       || GlobalProperty.find_by_property('current_health_center_district')&.property_value

          return district if district

          GlobalProperty.create(property: 'current_health_center_district',
                                property_value: Lims::Config.application['district'],
                                uuid: SecureRandom.uuid)

          Config.application['district']
        end

        def current_facility_name(order)
          current_health_center(order).name
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
