# frozen_string_literal: true

module Lab
  module LabOrderSerializer
    def self.serialize_order(order, tests: nil, requesting_clinician: nil, reason_for_test: nil, target_lab: nil)
      tests ||= order.tests
      requesting_clinician ||= order.requesting_clinician
      reason_for_test ||= order.reason_for_test
      target_lab ||= order.target_lab

      ActiveSupport::HashWithIndifferentAccess.new(
        {
          order_id: order.order_id,
          encounter_id: order.encounter_id,
          order_date: order.start_date,
          patient_id: order.patient_id,
          accession_number: order.accession_number,
          specimen: {
            concept_id: order.concept_id,
            name: concept_name(order.concept_id)
          },
          requesting_clinician: requesting_clinician&.value_text,
          target_lab: target_lab&.value_text,
          reason_for_test: {
            concept_id: reason_for_test&.value_coded,
            name: concept_name(reason_for_test&.value_coded)
          },
          tests: tests.map do |test|
            result = if test.respond_to?(:result) && test.result
                       {
                         id: test.result&.obs_id,
                         value: test.result&.value_text,
                         date: test.result&.obs_datetime
                       }
                     end

            {
              id: test.obs_id,
              concept_id: test.value_coded,
              name: concept_name(test.value_coded),
              result: result
            }
          end
        }
      )
    end

    def self.concept_name(concept_id)
      return concept_id unless concept_id

      ConceptName.find_by_concept_id(concept_id)&.name
    end
  end
end
