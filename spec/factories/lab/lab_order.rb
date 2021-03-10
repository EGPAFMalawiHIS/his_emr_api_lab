# frozen_string_literal: true

module Lab
  FactoryBot.define do
    factory :lab_order, class: 'Lab::LabOrder' do
      association :concept

      order_type { create(:order_type, name: Lab::Metadata::ORDER_TYPE_NAME) }

      provider { User.first }
      creator { User.last&.user_id || create(:user).user_id }
    end
  end
end
