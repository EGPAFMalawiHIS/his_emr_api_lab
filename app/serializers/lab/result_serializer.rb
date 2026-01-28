# frozen_string_literal: true

module Lab
  ##
  # Serialize a Lab order result
  module ResultSerializer
    def self.serialize(result)
      result.children.map do |measure|
        value, value_type = read_value(measure)
        # Get the test catalog name instead of any random concept name
        concept_name = get_test_catalog_concept_name(measure.concept_id)
        program_id = ''
        if measure.obs_id.present?
          obs = Observation.unscope(where: :obs_group_id).find(measure.obs_id)
          encounter = Encounter.find(obs.encounter_id)
          program_id = encounter.program_id
        end

        {
          id: measure.obs_id,
          indicator: {
            concept_id: measure.concept_id,
            name: concept_name
          },
          date: measure.obs_datetime,
          value:,
          value_type:,
          value_modifier: measure.value_modifier,
          program_id: program_id
        }
      end
    end

    def self.get_test_catalog_concept_name(concept_id)
      return nil unless concept_id

      ::ConceptAttribute.find_by(concept_id:, attribute_type: ConceptAttributeType.test_catalogue_name)&.value_reference
    end

    def self.read_value(measure)
      %w[value_numeric value_coded value_boolean value_text].each do |field|
        value = measure.send(field) if measure.respond_to?(field)

        return [value, field.split('_')[1]] if value
      end

      [nil, 'unknown']
    end
  end
end
