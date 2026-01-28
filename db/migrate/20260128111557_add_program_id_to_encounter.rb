# frozen_string_literal: true

# This migration adds the program_id column to the encounter table if it doesn't already exist.
# The program_id column is used to associate encounters with specific programs (e.g., HIV Program, TB Program).
class AddProgramIdToEncounter < ActiveRecord::Migration[5.2]
  def change
    return if column_exists?(:encounter, :program_id)

    add_column :encounter, :program_id, :integer, after: :encounter_type
    add_index :encounter, :program_id
    add_foreign_key :encounter, :program, column: :program_id, primary_key: :program_id
  end
end
