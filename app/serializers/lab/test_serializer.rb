# rubocop:disable Lint/UnreachableLoop
# frozen_string_literal: true

module Lab
  module TestSerializer
    def self.serialize(test, order: nil, result: nil)
      order ||= test.order
      result ||= test.result

      {
        id: test.obs_id,
        test_uuid: test.uuid,
        concept_id: test.value_coded,
        concept_uuid: test.value_coded ? Concept.find(test.value_coded)&.uuid : nil,
        name: ConceptName.find_by_concept_id(test.value_coded)&.name,
        order: {
          id: order.order_id,
          concept_id: order.concept_id,
          concept_uuid: order.concept_id ? Concept.find(order.concept_id)&.uuid : nil,
          name: ConceptName.find_by_concept_id(order.concept_id)&.name,
          accession_number: order.accession_number
        },
        measures: result_mesures(result),
        result: if result
                  {
                    id: result.obs_id,
                    modifier: result.value_modifier,
                    value: result.value_text
                  }
                end
      }
    end

    def self.result_mesures(result)
      if result&.measures.present?
        return result&.measures&.map do |measure|
          m = {}
          m[:uuid] = measure.uuid
          m[:concept_id] = measure.concept_id
          m[:name] = ConceptName.find_by_concept_id(measure.concept_id)&.name
          m[:modifier] = measure.value_modifier
          m[:value] = measure&.value_text || measure&.value_numeric || measure&.value_boolean || measure&.value_coded || measure&.value_datetime || measure&.value_drug || measure&.value_complex || measure&.value_group
          m
        end
      end

      nil
    end
  end
end

# rubocop:enable Lint/UnreachableLoop
