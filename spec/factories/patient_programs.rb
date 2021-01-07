# frozen_string_literal: true

FactoryBot.define do
  factory :patient_program do
    association :patient
    association :program
    date_enrolled { Time.now }
    location_id { 700 }
    creator { User.last&.user_id || create(:user).user_id }
  end
end
