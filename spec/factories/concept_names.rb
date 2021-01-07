# frozen_string_literal: true

FactoryBot.define do
  factory :concept_name do
    date_created { Time.now }
    association :concept
    creator { User.last&.user_id || create(:user).user_id }
    name { Faker::Cannabis.cannabinoid }
  end
end
