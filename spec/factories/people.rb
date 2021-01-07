# frozen_string_literal: true

FactoryBot.define do
  factory :person do
    gender { 'F' }
    birthdate { 18.years.ago }
    creator { User.last&.user_id || create(:user).user_id }
  end
end
