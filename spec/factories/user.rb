# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    username { Faker::Name.unique.first_name }
    password { 'password' }
    person { create(:person) }
    creator { User.current&.user_id || User.first.user_id }
  end
end
