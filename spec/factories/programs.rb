# frozen_string_literal: true

FactoryBot.define do
  factory :program do
    association :concept
    creator { User.last&.user_id || create(:user).user_id }
    description { 'foobar' }
    name { 'foobar' }
  end
end
