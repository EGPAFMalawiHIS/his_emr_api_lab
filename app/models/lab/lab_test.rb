# frozen_string_literal: true

module Lab
  class LabTest < ::Observation
    default_scope do
      where(concept: ConceptName.where(name: Lab::Metadata::TEST_TYPE_CONCEPT_NAME))
    end

    has_one :result,
            -> { where(concept: ConceptName.where(name: Lab::Metadata::TEST_RESULT_CONCEPT_NAME)) },
            class_name: 'Lab::LabResult',
            foreign_key: :obs_group_id

    has_many :status_trails,
             class_name: '::Lab::TestStatusTrail',
             foreign_key: :test_id,
             primary_key: :obs_id,
             dependent: :destroy

    def void(reason)
      result&.void(reason)
      super
    end
  end
end
