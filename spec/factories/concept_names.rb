# frozen_string_literal: true

FactoryBot.define do
  factory :concept_name do
    date_created { Time.now }
    association :concept
    creator { User.last&.user_id || create(:user).user_id }
    # Unique, because the services look concepts up by name.
    sequence(:name) { |n| "#{Faker::Cannabis.cannabinoid} #{n}" }
  end
end
