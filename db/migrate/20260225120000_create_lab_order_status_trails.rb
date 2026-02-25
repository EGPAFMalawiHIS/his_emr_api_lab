# frozen_string_literal: true

class CreateLabOrderStatusTrails < ActiveRecord::Migration[5.2]
  def change
    create_table :lab_order_status_trails do |t|
      t.integer :order_id, null: false
      t.integer :status_id, null: false
      t.string :status, null: false
      t.datetime :timestamp, null: false
      t.string :updated_by_first_name
      t.string :updated_by_last_name
      t.string :updated_by_id
      t.string :updated_by_phone_number

      t.timestamps

      t.foreign_key :orders, primary_key: :order_id, column: :order_id
      t.index :order_id
      t.index %i[order_id timestamp]
    end
  end
end
