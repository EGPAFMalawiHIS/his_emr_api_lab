# frozen_string_literal: true

module Lab
  class LabOrder < ::Order
    class << self
      def make_obs_concept_filter(concept_name)
        concept = ConceptName.where(name: concept_name).select(:concept_id)

        -> { where(concept:) }
      end

      # Cache the concept ID to avoid lookups in association scopes
      def order_status_concept_id
        @order_status_concept_id ||= ConceptName.find_by(name: 'Lab Order Status')&.concept_id
      end
    end

    has_many :tests,
             make_obs_concept_filter(Lab::Metadata::TEST_TYPE_CONCEPT_NAME),
             class_name: '::Lab::LabTest',
             foreign_key: :order_id

    has_many :results,
             make_obs_concept_filter(Lab::Metadata::TEST_RESULT_CONCEPT_NAME),
             class_name: 'Observation',
             foreign_key: :order_id

    has_one :reason_for_test,
            make_obs_concept_filter(Lab::Metadata::REASON_FOR_TEST_CONCEPT_NAME),
            class_name: 'Observation',
            foreign_key: :order_id

    has_one :requesting_clinician,
            make_obs_concept_filter(Lab::Metadata::REQUESTING_CLINICIAN_CONCEPT_NAME),
            class_name: 'Observation',
            foreign_key: :order_id

    has_one :target_lab,
            make_obs_concept_filter(Lab::Metadata::TARGET_LAB_CONCEPT_NAME),
            class_name: 'Observation',
            foreign_key: :order_id

    has_one :comment_to_fulfiller,
            make_obs_concept_filter(Lab::Metadata::COMMENT_TO_FULFILLER_CONCEPT_NAME),
            class_name: 'Observation',
            foreign_key: :order_id

    has_one :mapping,
            class_name: '::Lab::LimsOrderMapping',
            foreign_key: :order_id

    # Status trails are stored as observations with concept 'Lab Order Status'
    has_many :status_trail_observations,
             lambda {
               unscoped.where(voided: 0, concept_id: Lab::LabOrder.order_status_concept_id).order(date_created: :asc)
             },
             class_name: 'Observation',
             foreign_key: :order_id

    default_scope do
      joins(:order_type)
        .merge(OrderType.where(name: [
                                 Lab::Metadata::ORDER_TYPE_NAME,
                                 Lab::Metadata::HTS_ORDER_TYPE_NAME
                               ]))
        .where.not(concept_id: ConceptName.where(name: 'Tests ordered').select(:concept_id))
    end

    # Only checked when start_date is set or changed, so existing future-dated
    # orders can still be voided or updated during clean-up.
    validate :start_date_cannot_be_in_the_future, if: :will_save_change_to_start_date?

    scope :drawn, -> { where.not(concept_id: ConceptName.where(name: 'Unknown').select(:concept_id)) }
    scope :not_drawn, -> { where(concept_id: ConceptName.where(name: 'Unknown').select(:concept_id)) }

    def self.prefetch_relationships
      # NOTE: status_trail_observations and test results are not preloaded due to
      # Rails limitations with eager loading unscoped associations. They load on-demand instead.
      preload(:reason_for_test,
              :requesting_clinician,
              :target_lab,
              :comment_to_fulfiller,
              :tests)
    end

    # Allows up to tomorrow to cover timezone differences, matching
    # Lab::Lims::Utils.parse_date.
    def start_date_cannot_be_in_the_future
      return if start_date.blank? || start_date.to_date <= Date.current + 1.day

      errors.add(:start_date, 'cannot be in the future')
    end
  end
end
