# frozen_string_literal: true

module Lab
  class LabOrderSpecimen < ::Observation
    default_scope do
      where(concept: ConceptName.where(LabOrder::SPECIMEN_TYPE_CONCEPT_NAME), voided: false)
    end

    has_one :result,
            -> { where(concept: ConceptName.where(name: LabOrder::LAB_TEST_RESULT_CONCEPT_NAME)) },
            class_name: 'Observation',
            foreign_key: :obs_group_id
  end
end
