# frozen_string_literal: true

FactoryBot.define do
  factory :lims_order_mapping, class: 'Lab::LimsOrderMapping' do
    association :order, factory: :lab_order
    lims_id { 1 }
  end
end
