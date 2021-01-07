# frozen_string_literal: true

FactoryBot.define do
  factory :patient do
    patient_id { create(:person).person_id }
    creator { User.last&.user_id || create(:user).user_id }
  end
end
