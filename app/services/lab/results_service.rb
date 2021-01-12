# frozen_string_literal: true

module Lab
  module ResultsService
    class << self
      def create_result(test, params)
        encounter = find_encounter(test, params)
        result = Lab::LabResult.create(
          person_id: test.person_id,
          encounter_id: encounter.encounter_id,
          concept_id: ConceptName.find_by_name!(LabOrder::LAB_TEST_RESULT_CONCEPT_NAME).concept_id,
          order_id: test.order_id,
          obs_group_id: test.obs_id,
          obs_datetime: params[:date]&.to_datetime || DateTime.now,
          value_modifier: params[:modifier],
          value_text: params[:value]
        )

        Lab::ResultSerializer.serialize(result)
      end

      private

      def find_encounter(test, params)
        return Encounter.find(params[:encounter_id]) if params[:encounter_id]

        Encounter.create!(
          patient_id: test.person_id,
          program_id: test.encounter.program_id,
          type: EncounterType.find_by_name!(Lab::LabEncounter::ENCOUNTER_TYPE_NAME),
          encounter_datetime: params[:date] || Date.today,
          provider_id: params[:provider_id]
        )
      end
    end
  end
end
