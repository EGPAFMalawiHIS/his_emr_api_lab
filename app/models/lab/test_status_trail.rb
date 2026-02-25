# frozen_string_literal: true

module Lab
  class TestStatusTrail < ApplicationRecord
    self.table_name = :lab_test_status_trails
    self.primary_key = :id

    belongs_to :test,
               class_name: '::Lab::LabTest',
               foreign_key: :test_id,
               primary_key: :obs_id

    validates :test_id, presence: true
    validates :status, presence: true
    validates :timestamp, presence: true

    def updated_by
      return nil unless updated_by_first_name || updated_by_last_name

      {
        first_name: updated_by_first_name,
        last_name: updated_by_last_name,
        id: updated_by_id,
        phone_number: updated_by_phone_number
      }
    end
  end
end
