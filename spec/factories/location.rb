# frozen_string_literal: true

FactoryBot.define do
  factory :location do
    name { Faker::Address.city }

    date_created { Time.now }
  end
end
