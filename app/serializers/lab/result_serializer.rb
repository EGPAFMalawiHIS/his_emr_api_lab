# frozen_string_literal: true

module Lab
  module ResultSerializer
    def self.serialize(result)
      {
        id: result.obs_id,
        value: result.value_text,
        modifier: result.value_modifier,
        date: result.obs_datetime
      }
    end
  end
end
