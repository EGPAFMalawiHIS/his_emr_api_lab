# frozen_string_literal: true

module Lab
  ##
  # Serialize a Lab order result
  module ResultSerializer
    def self.serialize(result)
      result.children.map do |measure|
        value, value_type = read_value(measure)
        concept_name = ConceptName.find_by_concept_id(measure.concept_id)
        
        program_id = ""
        if measure.obs_id.present?
          obs = Observation.find(measure.obs_id)
          encounter = Encounter.find(obs.encounter_id)
          program_id = encounter.program_id
        end

        {
          id: measure.obs_id,
          indicator: {
            concept_id: concept_name&.concept_id,
            name: concept_name&.name
          },
          date: measure.obs_datetime,
          value:,
          value_type:,
          value_modifier: measure.value_modifier,
          program_id: program_id
        }
      end
    end

    def self.read_value(measure)
      %w[value_numeric value_coded value_boolean value_text].each do |field|
        value = measure.send(field)

        return [value, field.split('_')[1]] if value
      end

      [nil, 'unknown']
    end
  end
end
