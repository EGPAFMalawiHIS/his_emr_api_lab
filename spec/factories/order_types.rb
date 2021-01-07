# frozen_string_literal: true

require 'securerandom'

FactoryBot.define do
  factory :order_type do
    name { SecureRandom.hex }
    uuid { SecureRandom.uuid }
    creator { User.last&.user_id || create(:user).user_id }
    date_created { Time.now }
  end
end
