# frozen_string_literal: true

module Lab
  class LabOrder < ::Order
    class << self
      def make_obs_concept_filter(concept_name)
        concept = ConceptName.where('name LIKE ?', concept_name).select(:concept_id)

        -> { where(concept: concept) }
      end
    end

    ORDER_TYPE_NAME = 'Lab order'
    REASON_FOR_TEST_CONCEPT_NAME = 'Reason for test'
    REQUESTING_CLINICIAN_CONCEPT_NAME = 'Requesting Clinician'
    SPECIMEN_TYPE_CONCEPT_NAME = 'Specimen'
    TARGET_LAB_CONCEPT_NAME = 'Target Lab'
    TEST_TYPE_CONCEPT_NAME = 'Test type'
    LAB_TEST_RESULT_CONCEPT_NAME = 'Lab test result'

    has_many :specimens,
             make_obs_concept_filter(SPECIMEN_TYPE_CONCEPT_NAME),
             class_name: '::Lab::LabOrderSpecimen',
             foreign_key: :order_id

    has_many :results,
             make_obs_concept_filter(LAB_TEST_RESULT_CONCEPT_NAME),
             class_name: 'Observation',
             foreign_key: :order_id

    has_one :reason_for_test,
            make_obs_concept_filter(REASON_FOR_TEST_CONCEPT_NAME),
            class_name: 'Observation',
            foreign_key: :order_id

    has_one :requesting_clinician,
            make_obs_concept_filter(REQUESTING_CLINICIAN_CONCEPT_NAME),
            class_name: 'Observation',
            foreign_key: :order_id

    has_one :target_lab,
            make_obs_concept_filter(TARGET_LAB_CONCEPT_NAME),
            class_name: 'Observation',
            foreign_key: :order_id

    default_scope do
      joins(:order_type)
        .merge(OrderType.where('name LIKE ?', ORDER_TYPE_NAME))
        .where(voided: false)
    end

    def self.prefetch_relationships
      includes(:reason_for_test,
               :requesting_clinician,
               :target_lab,
               specimens: [:result])
    end
  end
end
