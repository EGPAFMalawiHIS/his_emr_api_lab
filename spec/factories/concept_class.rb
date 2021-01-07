# frozen_string_literal: true

FactoryBot.define do
  factory :concept_class do
    name { 'foobar' }
    description { 'foobar' }
    creator { User.last&.user_id || create(:user).user_id }
    date_created { Time.now }
  end
end
