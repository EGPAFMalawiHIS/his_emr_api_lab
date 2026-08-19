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
          obs = Observation.unscope(where: :obs_group_id).find_by(obs_id: measure.obs_id)
          encounter = Encounter.find_by(encounter_id: obs&.encounter_id)
          program_id = encounter&.program_id
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

      concept_name = ::ConceptAttribute.find_by(concept_id:, attribute_type: ConceptAttributeType.test_catalogue_name)&.value_reference
      return concept_name if concept_name.present?

      # If the concept does not have a test catalog name, check if it is UA or HCT and return the appropriate name
      # Otherwise, return the first concept name associated with the concept_id
      # Handles the case where a concept has multiple names, such as UA and HCT, which are both associated with the same concept_id
      # NB: Mostly for Old Lab tests that have been migrated to the new system, where the concept_id is the same for both UA and HCT, but the concept_name is different
      # A Case of AETC - Name was not present in the concept attribute table, but was present in the concept name table, so we need to check both tables to get the correct name
      concepts = %w[UA HCT]
      concept_names = ::ConceptName.where(concept_id: concept_id)
      if concept_names.any? { |cn| concepts.include?(cn.name) }
        concept_name = concept_names.find { |cn| concepts.include?(cn.name) }&.name
      else
        concept_name = concept_names.first&.name
      end
      concept_name
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
