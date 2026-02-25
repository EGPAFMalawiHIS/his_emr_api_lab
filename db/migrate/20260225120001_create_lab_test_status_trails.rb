# frozen_string_literal: true

class CreateLabTestStatusTrails < ActiveRecord::Migration[5.2]
  def change
    create_table :lab_test_status_trails do |t|
      t.integer :test_id, null: false
      t.integer :status_id, null: false
      t.string :status, null: false
      t.datetime :timestamp, null: false
      t.string :updated_by_first_name
      t.string :updated_by_last_name
      t.string :updated_by_id
      t.string :updated_by_phone_number

      t.timestamps

      t.foreign_key :obs, primary_key: :obs_id, column: :test_id
      t.index :test_id
      t.index %i[test_id timestamp]
    end
  end
end
