# frozen_string_literal: true

require 'securerandom'

FactoryBot.define do
  factory :encounter_type do
    name { SecureRandom.hex }
    description { 'foobar' }
    creator { User.last&.user_id || create(:user).user_id }
    date_created { Time.now }
  end
end
