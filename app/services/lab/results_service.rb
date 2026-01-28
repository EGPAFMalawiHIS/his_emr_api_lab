# frozen_string_literal: true

module Lab
  module ResultsService
    class << self
      ##
      # Attach results to a test
      #
      # Params:
      #   test_id: The tests id (maps to obs_id of the test's observation in OpenMRS)
      #   params: A hash comprising the following fields
      #     - encounter_id: Encounter to create result under (can be ommitted but provider_id has to specified)
      #     - provider_id: Specify a provider for an encounter the result is going to be created under
      #     - date: Retrospective date when the result was received (can be ommitted, defaults to today)
      #     - measures: An array of measures. A measure is an object of the following structure
      #         - indicator: An object that has a concept_id field (concept_id of the indicator)
      #         - value_type: An enum that's limited to 'numeric', 'boolean', 'text', and 'coded'
      #   result_enter_by: A string that specifies who created the result
      def create_results(test_id, params, result_enter_by = 'LIMS')
        serializer = {}
        results_obs = {}
        ActiveRecord::Base.transaction do
          test = begin
            Lab::LabTest.find(test_id)
          rescue StandardError
            nil
          end
          test = Lab::LabTest.find_by_uuid(test_id) if test.blank?
          encounter = find_encounter(test, encounter_id: params[:encounter_id],
                                           encounter_uuid: params[:encounter],
                                           date: params[:date]&.to_date,
                                           provider_id: params[:provider_id])

          results_obs = create_results_obs(encounter, test, params[:date], params[:comments])
          params[:measures].map { |measure| add_measure_to_results(results_obs, measure, params[:date]) }
          OrderExtension.create!(creator: User.current, value: result_enter_by, order_id: results_obs.order_id,
                                 date_created: Time.now)

          serializer = Lab::ResultSerializer.serialize(results_obs)
        end

        # force commit all transactions
        ActiveRecord::Base.connection.commit_db_transaction

        # delay job by a second
        ProcessLabResultJob.set(wait: 1.second).perform_later(results_obs.id, serializer, result_enter_by)

        Rails.logger.info("Lab::ResultsService: Result created for test #{test_id} #{serializer}")
        serializer
      end

      def process_result_completion(results_obs, serializer, result_enter_by)
        process_acknowledgement(results_obs, result_enter_by)
        precess_notification_message(results_obs, serializer, result_enter_by)
      end

      private

      def precess_notification_message(result, values, result_enter_by)
        order = Order.find(result.order_id)
        data = { Type: result_enter_by,
                 Specimen: get_test_catalog_name(order.concept_id) || ConceptName.find_by(concept_id: order.concept_id)&.name,
                 'Test type': get_test_catalog_name(result.test.value_coded) || ConceptName.find_by(concept_id: result.test.value_coded)&.name,
                 'Accession number': order&.accession_number,
                 'Orde date': Order.columns.include?('start_date') ? order.start_date : order.date_created,
                 'ARV-Number': find_arv_number(result.person_id),
                 PatientID: result.person_id,
                 'Ordered By': Order.columns.include?('provider_id') ? order&.provider&.person&.name : Person.find(order.creator)&.name,
                 Result: values }.as_json
        NotificationService.new.create_notification(result_enter_by, data)
      end

      def process_acknowledgement(results, results_enter_by)
        Lab::AcknowledgementService.create_acknowledgement({ order_id: results.order_id, test: results.test.value_coded,
                                                             date_received: Time.now,
                                                             entered_by: results_enter_by })
      end

      def find_arv_number(patient_id)
        PatientIdentifier.joins(:type)
                         .merge(PatientIdentifierType.where(name: 'ARV Number'))
                         .where(patient_id:)
                         .first&.identifier
      end

      def find_encounter(test, encounter_id: nil, encounter_uuid: nil, date: nil, provider_id: nil)
        return Encounter.find(encounter_id) if encounter_id
        return Encounter.find_by_uuid(encounter_uuid) if encounter_uuid

        lab_encounter_type = EncounterType.find_by_name!(Lab::Metadata::ENCOUNTER_TYPE_NAME)

        encounter = Encounter.new
        encounter.patient_id = test.person_id
        encounter.program_id = test.encounter.program_id if Encounter.column_names.include?('program_id')
        encounter.visit_id = test.encounter.visit_id if Encounter.column_names.include?('visit_id')
        # Use bracket notation to set the encounter_type column directly (bypasses association)
        # This handles both Integer and EncounterType object
        encounter_type_value = lab_encounter_type.is_a?(Integer) ? lab_encounter_type : lab_encounter_type.encounter_type_id
        encounter[:encounter_type] = encounter_type_value
        encounter.encounter_datetime = date || Date.today
        encounter.provider_id = provider_id || User.current.user_id if Encounter.column_names.include?('provider_id')
        encounter.save!
        encounter.reload
        encounter
      end

      # Creates the parent observation for results to which the different measures are attached
      def create_results_obs(encounter, test, date, comments = nil)
        void_existing_results_obs(encounter, test)
        Lab::LabResult.create!(
          person_id: encounter.patient_id,
          encounter_id: encounter.encounter_id,
          concept_id: test_result_concept.concept_id,
          order_id: test.order_id,
          obs_group_id: test.obs_id,
          obs_datetime: date&.to_datetime || DateTime.now,
          comments:
        )
      end

      def void_existing_results_obs(encounter, test)
        result = Lab::LabResult.find_by(person_id: encounter.patient_id,
                                        concept_id: test_result_concept.concept_id,
                                        obs_group_id: test.obs_id)
        return unless result

        OrderExtension.find_by(order_id: result.order_id)&.void("Updated/overwritten by #{User.current.username}")
        result.measures.map { |child_obs| child_obs.void("Updated/overwritten by #{User.current.username}") }
        result.void("Updated/overwritten by #{User.current.username}")
      end

      def test_result_concept
        ConceptName.find_by_name!(Lab::Metadata::TEST_RESULT_CONCEPT_NAME)
      end

      def add_measure_to_results(results_obs, params, date)
        validate_measure_params(params)

        concept_id = params[:indicator][:concept_id] || Concept.find_concept_by_uuid(params.dig(:indicator,
                                                                                                :concept))&.id

        Observation.create!(
          person_id: results_obs.person_id,
          encounter_id: results_obs.encounter_id,
          order_id: results_obs.order_id,
          concept_id: concept_id,
          obs_group_id: results_obs.obs_id,
          obs_datetime: date&.to_datetime || DateTime.now,
          **make_measure_value(params)
        )
      end

      def validate_measure_params(params)
        raise InvalidParameterError, 'measures.value is required' if params[:value].blank?

        if params[:indicator]&.[](:concept_id).blank? && params[:indicator]&.[](:concept).blank?
          raise InvalidParameterError, 'measures.indicator.concept_id or concept is required'
        end

        params
      end

      # Converts user provided measure values to observation_values
      def make_measure_value(params)
        obs_value = { value_modifier: params[:value_modifier] }
        value_type = params[:value_type] || 'text'

        case value_type.downcase
        when 'numeric' then obs_value.merge(value_numeric: params[:value])
        when 'boolean' then obs_value.merge(value_boolean: parse_boolen_value(params[:value]))
        when 'coded' then obs_value.merge(value_coded: params[:value]) # Should we be collecting value_name_coded_id?
        when 'text' then obs_value.merge(value_text: params[:value])
        else raise InvalidParameterError, "Invalid value_type: #{params[:value_type]}"
        end
      end

      def parse_boolen_value(string)
        case string.downcase
        when 'true' then true
        when 'false' then false
        else raise InvalidParameterError, "Invalid boolean value: #{string}"
        end
      end

      def get_test_catalog_name(concept_id)
        return nil unless concept_id

        ::ConceptAttribute.find_by(concept_id:,
                                   attribute_type: ConceptAttributeType.test_catalogue_name)&.value_reference
      end
    end
  end
end
