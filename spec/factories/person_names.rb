# frozen_string_literal: true

FactoryBot.define do
  factory :person_name do
    association :person

    given_name { Faker::Name.first_name }
    family_name { Faker::Name.last_name }
    middle_name { Faker::Name.first_name }
  end
end
