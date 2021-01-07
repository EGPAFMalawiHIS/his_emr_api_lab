# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    association :concept
    association :order_type
    provider { User.first }
    creator { User.last&.user_id || create(:user).user_id }
  end
end
