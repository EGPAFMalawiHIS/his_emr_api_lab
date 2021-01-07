# frozen_string_literal: true

module Lab
  class LabEncounter < ::Encounter
    ENCOUNTER_TYPE_NAME = 'Lab'

    default_scope { joins(:type).merge(EncounterType.where('name LIKE ?', ENCOUNTER_TYPE_NAME)) }
  end
end
