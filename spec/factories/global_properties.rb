# frozen_string_literal: true

require 'securerandom'

FactoryBot.define do
  factory :global_property do
    uuid { SecureRandom.uuid }
    property { Faker::Name.unique.name }
    property_value { Faker::Game.title }
  end
end
