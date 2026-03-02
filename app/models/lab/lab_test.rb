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

    # Status trails are stored as observations with concept 'Lab Test Status'
    # They are linked via obs_group_id (this test obs is the parent)
    has_many :status_trail_observations,
             lambda {
               joins(:concept)
                 .merge(Concept.joins(:concept_names).where(concept_names: { name: 'Lab Test Status' }))
                 .order(obs_datetime: :asc)
             },
             class_name: 'Observation',
             foreign_key: :obs_group_id,
             primary_key: :obs_id

    def void(reason)
      result&.void(reason)
      super(reason)
    end
  end
end
