# frozen_string_literal: true

# This migration removes the dedicated status trail tables in favor of using obs table
class RemoveLabStatusTrailTables < ActiveRecord::Migration[5.2]
  def up
    drop_table :lab_order_status_trails if table_exists?(:lab_order_status_trails)
    drop_table :lab_test_status_trails if table_exists?(:lab_test_status_trails)
  end

  def down
    # Recreate tables if needed for rollback
    create_table :lab_order_status_trails do |t|
      t.integer :order_id, null: false
      t.integer :status_id, default: 0
      t.string :status, null: false
      t.datetime :timestamp, null: false
      t.string :updated_by_first_name
      t.string :updated_by_last_name
      t.string :updated_by_id
      t.string :updated_by_phone_number
      t.timestamps
    end

    add_index :lab_order_status_trails, :order_id
    add_index :lab_order_status_trails, %i[order_id status timestamp], unique: true,
                                                                       name: 'index_order_status_trails_unique'

    create_table :lab_test_status_trails do |t|
      t.integer :test_id, null: false
      t.integer :status_id, default: 0
      t.string :status, null: false
      t.datetime :timestamp, null: false
      t.string :updated_by_first_name
      t.string :updated_by_last_name
      t.string :updated_by_id
      t.string :updated_by_phone_number
      t.timestamps
    end

    add_index :lab_test_status_trails, :test_id
    add_index :lab_test_status_trails, %i[test_id status timestamp], unique: true,
                                                                     name: 'index_test_status_trails_unique'
  end
end
