# frozen_string_literal: true

module Lab
  class LabTest < ::Observation
    default_scope do
      where(concept: ConceptName.where(name: Lab::Metadata::TEST_TYPE_CONCEPT_NAME))
    end

    # Cache the concept IDs as class methods to avoid lookups in association scopes
    def self.test_status_concept_id
      @test_status_concept_id ||= ConceptName.find_by(name: 'Lab Test Status')&.concept_id
    end

    def self.test_result_concept_id
      @test_result_concept_id ||= ConceptName.find_by(name: Lab::Metadata::TEST_RESULT_CONCEPT_NAME)&.concept_id
    end

    has_one :result,
            -> { unscoped.where(voided: 0, concept_id: Lab::LabTest.test_result_concept_id) },
            class_name: 'Lab::LabResult',
            foreign_key: :obs_group_id

    # Status trails are stored as observations with concept 'Lab Test Status'
    # They are linked via obs_group_id (this test obs is the parent)
    has_many :status_trail_observations,
             lambda {
               unscoped.where(voided: 0, concept_id: Lab::LabTest.test_status_concept_id).order(obs_datetime: :asc)
             },
             class_name: 'Observation',
             foreign_key: :obs_group_id,
             primary_key: :obs_id

    def void(reason)
      result&.void(reason)
      super
    end
  end
end
