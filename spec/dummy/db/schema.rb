# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_09_28_133511) do
  create_table "concept", primary_key: "concept_id", id: :integer, force: :cascade do |t|
    t.integer "retired", limit: 2, default: 0, null: false
    t.string "short_name"
    t.text "description"
    t.text "form_text"
    t.integer "datatype_id", default: 0, null: false
    t.integer "class_id", default: 0, null: false
    t.integer "is_set", limit: 2, default: 0, null: false
    t.integer "creator", default: 0, null: false
    t.datetime "date_created", null: false
    t.integer "default_charge"
    t.string "version", limit: 50
    t.integer "changed_by"
    t.datetime "date_changed"
    t.integer "retired_by"
    t.datetime "date_retired"
    t.string "retire_reason"
    t.string "uuid", limit: 38, null: false
    t.index ["changed_by"], name: "user_who_changed_concept"
    t.index ["class_id"], name: "concept_classes"
    t.index ["creator"], name: "concept_creator"
    t.index ["datatype_id"], name: "concept_datatypes"
    t.index ["retired_by"], name: "user_who_retired_concept"
    t.index ["uuid"], name: "concept_uuid_index", unique: true
  end

  create_table "concept_answer", primary_key: "concept_answer_id", id: :integer, force: :cascade do |t|
    t.integer "concept_id", default: 0, null: false
    t.integer "answer_concept"
    t.integer "answer_drug"
    t.integer "creator", default: 0, null: false
    t.datetime "date_created", null: false
    t.string "uuid", limit: 38, null: false
    t.float "sort_weight", limit: 53
    t.index ["answer_concept"], name: "answer"
    t.index ["concept_id"], name: "answers_for_concept"
    t.index ["creator"], name: "answer_creator"
    t.index ["uuid"], name: "concept_answer_uuid_index", unique: true
  end

  create_table "concept_class", primary_key: "concept_class_id", id: :integer, force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "description", default: "", null: false
    t.integer "creator", default: 0, null: false
    t.datetime "date_created", null: false
    t.integer "retired", limit: 2, default: 0, null: false
    t.integer "retired_by"
    t.datetime "date_retired"
    t.string "retire_reason"
    t.string "uuid", limit: 38, null: false
    t.index ["creator"], name: "concept_class_creator"
    t.index ["retired"], name: "concept_class_retired_status"
    t.index ["retired_by"], name: "user_who_retired_concept_class"
    t.index ["uuid"], name: "concept_class_uuid_index", unique: true
  end

  create_table "concept_complex", primary_key: "concept_id", id: :integer, default: nil, force: :cascade do |t|
    t.string "handler"
  end

  create_table "concept_datatype", primary_key: "concept_datatype_id", id: :integer, force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "hl7_abbreviation", limit: 3
    t.string "description", default: "", null: false
    t.integer "creator", default: 0, null: false
    t.datetime "date_created", null: false
    t.integer "retired", limit: 2, default: 0, null: false
    t.integer "retired_by"
    t.datetime "date_retired"
    t.string "retire_reason"
    t.string "uuid", limit: 38, null: false
    t.index ["creator"], name: "concept_datatype_creator"
    t.index ["retired"], name: "concept_datatype_retired_status"
    t.index ["retired_by"], name: "user_who_retired_concept_datatype"
    t.index ["uuid"], name: "concept_datatype_uuid_index", unique: true
  end

  create_table "concept_name", primary_key: "concept_name_id", id: :integer, force: :cascade do |t|
    t.integer "concept_id"
    t.string "name", default: "", null: false
    t.string "locale", limit: 50, default: "", null: false
    t.integer "creator", default: 0, null: false
    t.datetime "date_created", null: false
    t.integer "voided", limit: 2, default: 0, null: false
    t.integer "voided_by"
    t.datetime "date_voided"
    t.string "void_reason"
    t.string "uuid", limit: 38, null: false
    t.string "concept_name_type", limit: 50
    t.integer "locale_preferred", limit: 2, default: 0
    t.index ["concept_id"], name: "unique_concept_name_id"
    t.index ["concept_name_id"], name: "concept_name_id", unique: true
    t.index ["creator"], name: "user_who_created_name"
    t.index ["name"], name: "name_of_concept"
    t.index ["uuid"], name: "concept_name_uuid_index", unique: true
  end

  create_table "concept_numeric", primary_key: "concept_id", id: :integer, default: 0, force: :cascade do |t|
    t.float "hi_absolute", limit: 53
    t.float "hi_critical", limit: 53
    t.float "hi_normal", limit: 53
    t.float "low_absolute", limit: 53
    t.float "low_critical", limit: 53
    t.float "low_normal", limit: 53
    t.string "units", limit: 50
    t.integer "precise", limit: 2, default: 0, null: false
  end

  create_table "concept_set", primary_key: "concept_set_id", id: :integer, force: :cascade do |t|
    t.integer "concept_id", default: 0, null: false
    t.integer "concept_set", default: 0, null: false
    t.float "sort_weight", limit: 53
    t.integer "creator", default: 0, null: false
    t.datetime "date_created", null: false
    t.string "uuid", limit: 38, null: false
    t.index ["concept_id"], name: "idx_concept_set_concept"
    t.index ["concept_set"], name: "has_a"
    t.index ["creator"], name: "user_who_created"
    t.index ["uuid"], name: "concept_set_uuid_index", unique: true
  end

  create_table "drug", primary_key: "drug_id", id: :integer, force: :cascade do |t|
    t.integer "concept_id", default: 0, null: false
    t.string "name", limit: 50
    t.integer "combination", limit: 2, default: 0, null: false
    t.integer "dosage_form"
    t.float "dose_strength", limit: 53
    t.float "maximum_daily_dose", limit: 53
    t.float "minimum_daily_dose", limit: 53
    t.integer "route"
    t.string "units", limit: 50
    t.integer "creator", default: 0, null: false
    t.datetime "date_created", null: false
    t.integer "retired", limit: 2, default: 0, null: false
    t.integer "retired_by"
    t.datetime "date_retired"
    t.string "retire_reason"
    t.string "uuid", limit: 38, null: false
    t.index ["concept_id"], name: "primary_drug_concept"
    t.index ["creator"], name: "drug_creator"
    t.index ["dosage_form"], name: "dosage_form_concept"
    t.index ["retired_by"], name: "user_who_voided_drug"
    t.index ["route"], name: "route_concept"
    t.index ["uuid"], name: "drug_uuid_index", unique: true
  end

  create_table "drug_order", primary_key: "order_id", id: :integer, default: 0, force: :cascade do |t|
    t.integer "drug_inventory_id", default: 0
    t.float "dose", limit: 53
    t.float "equivalent_daily_dose", limit: 53
    t.string "units"
    t.string "frequency"
    t.integer "prn", limit: 2, default: 0, null: false
    t.integer "complex", limit: 2, default: 0, null: false
    t.integer "quantity"
    t.index ["drug_inventory_id"], name: "inventory_item"
  end

  create_table "drug_order_barcodes", primary_key: "drug_order_barcode_id", id: :integer, force: :cascade do |t|
    t.integer "drug_id"
    t.integer "tabs"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "encounter", primary_key: "encounter_id", id: :integer, force: :cascade do |t|
    t.integer "encounter_type", null: false
    t.integer "patient_id", default: 0, null: false
    t.integer "provider_id", default: 0, null: false
    t.integer "location_id"
    t.integer "form_id"
    t.datetime "encounter_datetime", default: "1900-01-01 00:00:00", null: false
    t.integer "creator", default: 0, null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.integer "voided", limit: 2, default: 0, null: false
    t.integer "voided_by"
    t.datetime "date_voided"
    t.string "void_reason"
    t.string "uuid", limit: 38, null: false
    t.integer "changed_by"
    t.datetime "date_changed"
    t.integer "program_id", default: 1
    t.index ["changed_by"], name: "encounter_changed_by"
    t.index ["creator"], name: "encounter_creator"
    t.index ["encounter_datetime", "patient_id", "encounter_type"], name: "idx_person_encounters_by_date"
    t.index ["encounter_datetime"], name: "encounter_datetime_idx"
    t.index ["encounter_type"], name: "encounter_type_id"
    t.index ["form_id"], name: "encounter_form"
    t.index ["location_id"], name: "encounter_location"
    t.index ["patient_id", "encounter_type"], name: "idx_person_encounters"
    t.index ["patient_id"], name: "encounter_patient"
    t.index ["provider_id"], name: "encounter_provider"
    t.index ["uuid"], name: "encounter_uuid_index", unique: true
    t.index ["voided_by"], name: "user_who_voided_encounter"
  end

  create_table "encounter_type", primary_key: "encounter_type_id", id: :integer, force: :cascade do |t|
    t.string "name", limit: 50, default: "", null: false
    t.text "description"
    t.integer "creator", default: 0, null: false
    t.datetime "date_created", null: false
    t.integer "retired", limit: 2, default: 0, null: false
    t.integer "retired_by"
    t.datetime "date_retired"
    t.string "retire_reason"
    t.string "uuid", limit: 38, null: false
    t.index ["creator"], name: "user_who_created_type"
    t.index ["retired"], name: "encounter_retired_status"
    t.index ["retired_by"], name: "user_who_retired_encounter_type"
    t.index ["uuid"], name: "encounter_type_uuid_index", unique: true
  end

  create_table "global_property", id: :integer, force: :cascade do |t|
    t.string "property", default: "", null: false
    t.text "property_value", limit: 16777215
    t.text "description"
    t.string "uuid", limit: 38, null: false
    t.index ["uuid"], name: "global_property_uuid_index", unique: true
  end

  create_table "location", primary_key: "location_id", id: :integer, force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "description"
    t.string "address1", limit: 50
    t.string "address2", limit: 50
    t.string "city_village", limit: 50
    t.string "state_province", limit: 50
    t.string "postal_code", limit: 50
    t.string "country", limit: 50
    t.string "latitude", limit: 50
    t.string "longitude", limit: 50
    t.integer "creator", default: 0, null: false
    t.datetime "date_created", null: false
    t.string "county_district", limit: 50
    t.string "neighborhood_cell", limit: 50
    t.string "region", limit: 50
    t.string "subregion", limit: 50
    t.string "township_division", limit: 50
    t.boolean "retired", default: false, null: false
    t.integer "retired_by"
    t.datetime "date_retired"
    t.string "retire_reason"
    t.integer "location_type_id"
    t.integer "parent_location"
    t.string "uuid", limit: 38, null: false
    t.index ["creator"], name: "user_who_created_location"
    t.index ["location_type_id"], name: "type_of_location"
    t.index ["name"], name: "name_of_location"
    t.index ["parent_location"], name: "parent_location"
    t.index ["retired"], name: "location_retired_status"
    t.index ["retired_by"], name: "user_who_retired_location"
    t.index ["uuid"], name: "location_uuid_index", unique: true
  end

  create_table "location_tag", primary_key: "location_tag_id", id: :integer, force: :cascade do |t|
    t.string "tag", limit: 50
    t.string "description"
    t.integer "creator", null: false
    t.datetime "date_created", null: false
    t.integer "retired", limit: 2, default: 0, null: false
    t.integer "retired_by"
    t.datetime "date_retired"
    t.string "retire_reason"
    t.string "uuid", limit: 38, null: false
    t.index ["creator"], name: "location_tag_creator"
    t.index ["retired_by"], name: "location_tag_retired_by"
    t.index ["uuid"], name: "location_tag_uuid_index", unique: true
  end

  create_table "location_tag_map", primary_key: ["location_id", "location_tag_id"], force: :cascade do |t|
    t.integer "location_id", null: false
    t.integer "location_tag_id", null: false
    t.index ["location_tag_id"], name: "location_tag_map_tag"
  end

  create_table "location_tag_maps", id: :integer, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "obs", primary_key: "obs_id", id: :integer, force: :cascade do |t|
    t.integer "person_id", null: false
    t.integer "concept_id", default: 0, null: false
    t.integer "encounter_id"
    t.integer "order_id"
    t.datetime "obs_datetime", default: "1900-01-01 00:00:00", null: false
    t.integer "location_id"
    t.integer "obs_group_id"
    t.string "accession_number"
    t.integer "value_group_id"
    t.boolean "value_boolean"
    t.integer "value_coded"
    t.integer "value_coded_name_id"
    t.integer "value_drug"
    t.datetime "value_datetime"
    t.float "value_numeric", limit: 53
    t.string "value_modifier", limit: 2
    t.text "value_text"
    t.datetime "date_started"
    t.datetime "date_stopped"
    t.string "comments"
    t.integer "creator", default: 0, null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.integer "voided", limit: 2, default: 0, null: false
    t.integer "voided_by"
    t.datetime "date_voided"
    t.string "void_reason"
    t.string "value_complex"
    t.string "uuid", limit: 38, null: false
    t.index ["concept_id"], name: "obs_concept"
    t.index ["creator"], name: "obs_enterer"
    t.index ["encounter_id"], name: "encounter_observations"
    t.index ["location_id"], name: "obs_location"
    t.index ["obs_datetime", "person_id", "concept_id", "value_coded"], name: "idx_person_obs_answers_by_date"
    t.index ["obs_datetime"], name: "obs_datetime_idx"
    t.index ["obs_group_id"], name: "obs_grouping_id"
    t.index ["order_id"], name: "obs_order"
    t.index ["person_id", "concept_id", "value_coded"], name: "idx_person_obs_answer"
    t.index ["person_id", "obs_group_id", "value_coded"], name: "idx_obs_grouping"
    t.index ["person_id"], name: "patient_obs"
    t.index ["uuid"], name: "obs_uuid_index", unique: true
    t.index ["value_coded"], name: "answer_concept"
    t.index ["value_coded_name_id"], name: "obs_name_of_coded_value"
    t.index ["value_drug"], name: "answer_concept_drug"
    t.index ["voided_by"], name: "user_who_voided_obs"
  end

  create_table "order_type", primary_key: "order_type_id", id: :integer, force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "description", default: "", null: false
    t.integer "creator", default: 0, null: false
    t.datetime "date_created", null: false
    t.integer "retired", limit: 2, default: 0, null: false
    t.integer "retired_by"
    t.datetime "date_retired"
    t.string "retire_reason"
    t.string "uuid", limit: 38, null: false
    t.index ["creator"], name: "type_created_by"
    t.index ["retired"], name: "order_type_retired_status"
    t.index ["retired_by"], name: "user_who_retired_order_type"
    t.index ["uuid"], name: "order_type_uuid_index", unique: true
  end

  create_table "orders", primary_key: "order_id", id: :integer, force: :cascade do |t|
    t.integer "order_type_id", default: 0, null: false
    t.integer "concept_id", default: 0, null: false
    t.integer "orderer", default: 0
    t.integer "encounter_id"
    t.text "instructions"
    t.datetime "start_date"
    t.datetime "auto_expire_date"
    t.integer "discontinued", limit: 2, default: 0, null: false
    t.datetime "discontinued_date"
    t.integer "discontinued_by"
    t.integer "discontinued_reason"
    t.integer "creator", default: 0, null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.integer "voided", limit: 2, default: 0, null: false
    t.integer "voided_by"
    t.datetime "date_voided"
    t.string "void_reason"
    t.integer "patient_id", null: false
    t.string "accession_number"
    t.integer "obs_id"
    t.string "uuid", limit: 38, null: false
    t.string "discontinued_reason_non_coded"
    t.index ["creator"], name: "order_creator"
    t.index ["discontinued_by"], name: "user_who_discontinued_order"
    t.index ["discontinued_reason"], name: "discontinued_because"
    t.index ["encounter_id"], name: "orders_in_encounter"
    t.index ["obs_id"], name: "obs_for_order"
    t.index ["order_type_id"], name: "type_of_order"
    t.index ["orderer"], name: "orderer_not_drug"
    t.index ["patient_id"], name: "order_for_patient"
    t.index ["start_date", "patient_id", "concept_id", "order_type_id"], name: "idx_order"
    t.index ["uuid"], name: "orders_uuid_index", unique: true
    t.index ["voided_by"], name: "user_who_voided_order"
  end

  create_table "patient", primary_key: "patient_id", id: :integer, force: :cascade do |t|
    t.integer "tribe"
    t.integer "creator", default: 0, null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.integer "changed_by"
    t.datetime "date_changed"
    t.integer "voided", limit: 2, default: 0, null: false
    t.integer "voided_by"
    t.datetime "date_voided"
    t.string "void_reason"
  end

  create_table "patient_identifier", primary_key: "patient_identifier_id", id: :integer, force: :cascade do |t|
    t.integer "patient_id", default: 0, null: false
    t.string "identifier", limit: 50, default: "", null: false
    t.integer "identifier_type", default: 0, null: false
    t.integer "preferred", limit: 2, default: 0, null: false
    t.integer "location_id", default: 0, null: false
    t.integer "creator", default: 0, null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.integer "voided", limit: 2, default: 0, null: false
    t.integer "voided_by"
    t.datetime "date_voided"
    t.string "void_reason"
    t.string "uuid", limit: 38, null: false
    t.index ["creator"], name: "identifier_creator"
    t.index ["identifier"], name: "identifier_name"
    t.index ["identifier_type"], name: "defines_identifier_type"
    t.index ["location_id"], name: "identifier_location"
    t.index ["patient_id"], name: "idx_patient_identifier_patient"
    t.index ["uuid"], name: "patient_identifier_uuid_index", unique: true
    t.index ["voided_by"], name: "identifier_voider"
  end

  create_table "patient_identifier_type", primary_key: "patient_identifier_type_id", id: :integer, force: :cascade do |t|
    t.string "name", limit: 50, default: "", null: false
    t.text "description", null: false
    t.string "format", limit: 50
    t.integer "check_digit", limit: 2, default: 0, null: false
    t.integer "creator", default: 0, null: false
    t.datetime "date_created", null: false
    t.integer "required", limit: 2, default: 0, null: false
    t.string "format_description"
    t.string "validator", limit: 200
    t.integer "retired", limit: 2, default: 0, null: false
    t.integer "retired_by"
    t.datetime "date_retired"
    t.string "retire_reason"
    t.string "uuid", limit: 38, null: false
    t.index ["retired"], name: "patient_identifier_type_retired_status"
    t.index ["retired_by"], name: "user_who_retired_patient_identifier_type"
    t.index ["uuid"], name: "patient_identifier_type_uuid_index", unique: true
  end

  create_table "patient_program", primary_key: "patient_program_id", id: :integer, force: :cascade do |t|
    t.integer "patient_id", default: 0, null: false
    t.integer "program_id", default: 0, null: false
    t.datetime "date_enrolled"
    t.datetime "date_completed"
    t.integer "creator", default: 0, null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.integer "changed_by"
    t.datetime "date_changed"
    t.integer "voided", limit: 2, default: 0, null: false
    t.integer "voided_by"
    t.datetime "date_voided"
    t.string "void_reason"
    t.string "uuid", limit: 38, null: false
    t.integer "location_id"
    t.index ["changed_by"], name: "user_who_changed"
    t.index ["creator"], name: "patient_program_creator"
    t.index ["patient_id"], name: "patient_in_program"
    t.index ["program_id"], name: "program_for_patient"
    t.index ["uuid"], name: "patient_program_uuid_index", unique: true
    t.index ["voided_by"], name: "user_who_voided_patient_program"
  end

  create_table "patient_state", primary_key: "patient_state_id", id: :integer, force: :cascade do |t|
    t.integer "patient_program_id", default: 0, null: false
    t.integer "state", default: 0, null: false
    t.date "start_date"
    t.date "end_date"
    t.integer "creator", default: 0, null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.integer "changed_by"
    t.datetime "date_changed"
    t.integer "voided", limit: 2, default: 0, null: false
    t.integer "voided_by"
    t.datetime "date_voided"
    t.string "void_reason"
    t.string "uuid", limit: 38, null: false
    t.index ["changed_by"], name: "patient_state_changer"
    t.index ["creator"], name: "patient_state_creator"
    t.index ["patient_program_id"], name: "patient_program_for_state"
    t.index ["state"], name: "state_for_patient"
    t.index ["uuid"], name: "patient_state_uuid_index", unique: true
    t.index ["voided_by"], name: "patient_state_voider"
  end

  create_table "person", primary_key: "person_id", id: :integer, force: :cascade do |t|
    t.string "gender", limit: 50, default: ""
    t.date "birthdate"
    t.integer "birthdate_estimated", limit: 2, default: 0, null: false
    t.integer "dead", limit: 2, default: 0, null: false
    t.datetime "death_date"
    t.integer "cause_of_death"
    t.integer "creator", null: true
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.integer "changed_by"
    t.datetime "date_changed"
    t.integer "voided", limit: 2, default: 0, null: false
    t.integer "voided_by"
    t.datetime "date_voided"
    t.string "void_reason"
    t.string "uuid", limit: 38, null: false
  end

  create_table "person_address", primary_key: "person_address_id", id: :integer, force: :cascade do |t|
    t.integer "person_id"
    t.integer "preferred", limit: 2, default: 0, null: false
    t.string "address1", limit: 50
    t.string "address2", limit: 50
    t.string "city_village", limit: 50
    t.string "state_province", limit: 50
    t.string "postal_code", limit: 50
    t.string "country", limit: 50
    t.string "latitude", limit: 50
    t.string "longitude", limit: 50
    t.integer "creator", default: 0, null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.integer "voided", limit: 2, default: 0, null: false
    t.integer "voided_by"
    t.datetime "date_voided"
    t.string "void_reason"
    t.string "county_district", limit: 50
    t.string "neighborhood_cell", limit: 50
    t.string "region", limit: 50
    t.string "subregion", limit: 50
    t.string "township_division", limit: 50
    t.string "uuid", limit: 38, null: false
    t.index ["creator"], name: "patient_address_creator"
    t.index ["date_created"], name: "index_date_created_on_person_address"
    t.index ["person_id"], name: "patient_addresses"
    t.index ["uuid"], name: "person_address_uuid_index", unique: true
    t.index ["voided_by"], name: "patient_address_void"
  end

  create_table "person_attribute", primary_key: "person_attribute_id", id: :integer, force: :cascade do |t|
    t.integer "person_id", default: 0, null: false
    t.string "value", limit: 120, default: "", null: false
    t.integer "person_attribute_type_id", default: 0, null: false
    t.integer "creator", default: 0, null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.integer "changed_by"
    t.datetime "date_changed"
    t.integer "voided", limit: 2, default: 0, null: false
    t.integer "voided_by"
    t.datetime "date_voided"
    t.string "void_reason"
    t.string "uuid", limit: 38, null: false
    t.index ["changed_by"], name: "attribute_changer"
    t.index ["creator"], name: "attribute_creator"
    t.index ["person_attribute_type_id"], name: "defines_attribute_type"
    t.index ["person_id"], name: "identifies_person"
    t.index ["uuid"], name: "person_attribute_uuid_index", unique: true
    t.index ["voided_by"], name: "attribute_voider"
  end

  create_table "person_attribute_type", primary_key: "person_attribute_type_id", id: :integer, force: :cascade do |t|
    t.string "name", limit: 50, default: "", null: false
    t.text "description", null: false
    t.string "format", limit: 50
    t.integer "foreign_key"
    t.integer "searchable", limit: 2, default: 0, null: false
    t.integer "creator", default: 0, null: false
    t.datetime "date_created", null: false
    t.integer "changed_by"
    t.datetime "date_changed"
    t.integer "retired", limit: 2, default: 0, null: false
    t.integer "retired_by"
    t.datetime "date_retired"
    t.string "retire_reason"
    t.string "edit_privilege"
    t.string "uuid", limit: 38, null: false
    t.float "sort_weight", limit: 53
  end

  create_table "person_name", primary_key: "person_name_id", id: :integer, force: :cascade do |t|
    t.integer "preferred", limit: 2, default: 0, null: false
    t.integer "person_id"
    t.string "prefix", limit: 50
    t.string "given_name", limit: 50
    t.string "middle_name", limit: 50
    t.string "family_name_prefix", limit: 50
    t.string "family_name", limit: 50
    t.string "family_name2", limit: 50
    t.string "family_name_suffix", limit: 50
    t.string "degree", limit: 50
    t.integer "creator", default: 0, null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.integer "voided", limit: 2, default: 0, null: false
    t.integer "voided_by"
    t.datetime "date_voided"
    t.string "void_reason"
    t.integer "changed_by"
    t.datetime "date_changed"
    t.string "uuid", limit: 38, null: false
    t.index ["creator"], name: "user_who_made_name"
    t.index ["family_name"], name: "last_name"
    t.index ["family_name2"], name: "family_name2"
    t.index ["given_name"], name: "first_name"
    t.index ["middle_name"], name: "middle_name"
    t.index ["uuid"], name: "person_name_uuid_index", unique: true
  end

  create_table "person_name_code", primary_key: "person_name_code_id", id: :integer, force: :cascade do |t|
    t.integer "person_name_id"
    t.string "given_name_code", limit: 50
    t.string "middle_name_code", limit: 50
    t.string "family_name_code", limit: 50
    t.string "family_name2_code", limit: 50
    t.string "family_name_suffix_code", limit: 50
    t.index ["family_name_code"], name: "family_name_code"
    t.index ["given_name_code", "family_name_code"], name: "given_family_name_code"
    t.index ["given_name_code"], name: "given_name_code"
    t.index ["middle_name_code"], name: "middle_name_code"
  end

  create_table "pharmacy_batch_item_reallocations", force: :cascade do |t|
    t.string "reallocation_code"
    t.integer "batch_item_id"
    t.float "quantity"
    t.integer "location_id"
    t.string "reallocation_type"
    t.date "date"
    t.datetime "date_created", null: false
    t.integer "creator", null: false
    t.datetime "date_changed", null: false
    t.integer "voided", limit: 2
    t.datetime "date_voided"
    t.integer "voided_by"
    t.string "void_reason"
    t.index ["reallocation_type"], name: "index_pharmacy_batch_item_reallocations_on_reallocation_type"
  end

  create_table "pharmacy_batch_items", force: :cascade do |t|
    t.integer "pharmacy_batch_id"
    t.integer "drug_id"
    t.float "delivered_quantity"
    t.float "current_quantity"
    t.date "delivery_date"
    t.date "expiry_date"
    t.integer "creator", null: false
    t.datetime "date_created", default: -> { "current_timestamp" }, null: false
    t.datetime "date_changed", default: -> { "current_timestamp" }
    t.boolean "voided"
    t.integer "voided_by"
    t.string "void_reason"
    t.datetime "date_voided"
  end

  create_table "pharmacy_batches", force: :cascade do |t|
    t.string "batch_number"
    t.integer "creator", null: false
    t.datetime "date_created", default: -> { "current_timestamp" }, null: false
    t.datetime "date_changed"
    t.boolean "voided"
    t.integer "voided_by"
    t.string "void_reason"
    t.datetime "date_voided"
  end

  create_table "pharmacy_encounter_type", primary_key: "pharmacy_encounter_type_id", id: :integer, force: :cascade do |t|
    t.string "name", limit: 50, null: false
    t.text "description", null: false
    t.string "format", limit: 50
    t.integer "foreign_key"
    t.boolean "searchable"
    t.integer "creator", default: 0, null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.integer "changed_by"
    t.datetime "date_changed"
    t.boolean "retired", default: false, null: false
    t.integer "retired_by"
    t.datetime "date_retired"
    t.string "retire_reason", limit: 225
  end

  create_table "pharmacy_obs", primary_key: "pharmacy_module_id", id: :integer, force: :cascade do |t|
    t.integer "pharmacy_encounter_type", default: 0, null: false
    t.integer "drug_id", default: 0, null: false
    t.float "value_numeric", limit: 53
    t.float "expiring_units", limit: 53
    t.integer "pack_size"
    t.integer "value_coded"
    t.string "value_text", limit: 15
    t.date "expiry_date"
    t.date "encounter_date", default: "1900-01-01", null: false
    t.integer "creator", null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.integer "changed_by"
    t.datetime "date_changed"
    t.boolean "voided", default: false, null: false
    t.integer "voided_by"
    t.datetime "date_voided"
    t.string "void_reason", limit: 225
    t.integer "batch_item_id"
  end

  create_table "privilege", primary_key: "privilege", id: :string, limit: 50, default: "", force: :cascade do |t|
    t.string "description", limit: 250, default: "", null: false
    t.string "uuid", limit: 38, null: false
    t.index ["uuid"], name: "privilege_uuid_index", unique: true
  end

  create_table "program", primary_key: "program_id", id: :integer, force: :cascade do |t|
    t.integer "concept_id", default: 0, null: false
    t.integer "creator", default: 0, null: false
    t.datetime "date_created", null: false
    t.integer "changed_by"
    t.datetime "date_changed"
    t.integer "retired", limit: 2, default: 0, null: false
    t.string "name", limit: 50, null: false
    t.string "description", limit: 500
    t.string "uuid", limit: 38, null: false
    t.index ["changed_by"], name: "user_who_changed_program"
    t.index ["concept_id"], name: "program_concept"
    t.index ["creator"], name: "program_creator"
    t.index ["uuid"], name: "program_uuid_index", unique: true
  end

  create_table "program_workflow", primary_key: "program_workflow_id", id: :integer, force: :cascade do |t|
    t.integer "program_id", default: 0, null: false
    t.integer "concept_id", default: 0, null: false
    t.integer "creator", default: 0, null: false
    t.datetime "date_created", null: false
    t.integer "retired", limit: 2, default: 0, null: false
    t.integer "changed_by"
    t.datetime "date_changed"
    t.string "uuid", limit: 38, null: false
    t.index ["changed_by"], name: "workflow_voided_by"
    t.index ["concept_id"], name: "workflow_concept"
    t.index ["creator"], name: "workflow_creator"
    t.index ["program_id"], name: "program_for_workflow"
    t.index ["uuid"], name: "program_workflow_uuid_index", unique: true
  end

  create_table "program_workflow_state", primary_key: "program_workflow_state_id", id: :integer, force: :cascade do |t|
    t.integer "program_workflow_id", default: 0, null: false
    t.integer "concept_id", default: 0, null: false
    t.integer "initial", limit: 2, default: 0, null: false
    t.integer "terminal", limit: 2, default: 0, null: false
    t.integer "creator", default: 0, null: false
    t.datetime "date_created", null: false
    t.integer "retired", limit: 2, default: 0, null: false
    t.integer "changed_by"
    t.datetime "date_changed"
    t.string "uuid", limit: 38, null: false
    t.index ["changed_by"], name: "state_voided_by"
    t.index ["concept_id"], name: "state_concept"
    t.index ["creator"], name: "state_creator"
    t.index ["program_workflow_id"], name: "workflow_for_state"
    t.index ["uuid"], name: "program_workflow_state_uuid_index", unique: true
  end

  create_table "relationship", primary_key: "relationship_id", id: :integer, force: :cascade do |t|
    t.integer "person_a", null: false
    t.integer "relationship", default: 0, null: false
    t.integer "person_b", null: false
    t.integer "creator", default: 0, null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.integer "voided", limit: 2, default: 0, null: false
    t.integer "voided_by"
    t.datetime "date_voided"
    t.string "void_reason"
    t.string "uuid", limit: 38
    t.index ["creator"], name: "relation_creator"
    t.index ["person_a"], name: "related_person"
    t.index ["person_b"], name: "related_relative"
    t.index ["uuid"], name: "relationship_uuid_index", unique: true
    t.index ["voided_by"], name: "relation_voider"
  end

  create_table "relationship_type", primary_key: "relationship_type_id", id: :integer, force: :cascade do |t|
    t.string "a_is_to_b", limit: 50, null: false
    t.string "b_is_to_a", limit: 50, null: false
    t.integer "preferred", default: 0, null: false
    t.integer "weight", default: 0, null: false
    t.string "description", default: "", null: false
    t.integer "creator", default: 0, null: false
    t.datetime "date_created", null: false
    t.string "uuid", limit: 38, null: false
    t.boolean "retired", default: false, null: false
    t.integer "retired_by"
    t.datetime "date_retired"
    t.string "retire_reason"
    t.index ["creator"], name: "user_who_created_rel"
    t.index ["retired_by"], name: "user_who_retired_relationship_type"
    t.index ["uuid"], name: "relationship_type_uuid_index", unique: true
  end

  create_table "role", primary_key: "role", id: :string, limit: 50, default: "", force: :cascade do |t|
    t.string "description", default: "", null: false
    t.string "uuid", limit: 38, null: false
    t.index ["uuid"], name: "role_uuid_index", unique: true
  end

  create_table "role_privilege", primary_key: ["privilege", "role"], force: :cascade do |t|
    t.string "role", limit: 50, default: "", null: false
    t.string "privilege", limit: 50, default: "", null: false
  end

  create_table "role_role", primary_key: ["parent_role", "child_role"], force: :cascade do |t|
    t.string "parent_role", limit: 50, default: "", null: false
    t.string "child_role", default: "", null: false
    t.index ["child_role"], name: "inherited_role"
  end

  create_table "user_programs", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "program_id"
    t.integer "voided", default: 0
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["program_id"], name: "index_user_programs_on_program_id"
    t.index ["user_id"], name: "index_user_programs_on_user_id"
  end

  create_table "user_property", primary_key: ["user_id", "property"], force: :cascade do |t|
    t.integer "user_id", default: 0, null: false
    t.string "property", limit: 100, default: "", null: false
    t.text "property_value"
  end

  create_table "user_role", primary_key: ["role", "user_id"], force: :cascade do |t|
    t.integer "user_id", default: 0, null: false
    t.string "role", limit: 50, default: "", null: false
  end

  create_table "users", primary_key: "user_id", id: :integer, force: :cascade do |t|
    t.string "system_id", limit: 50, default: "", null: false
    t.string "username", limit: 50
    t.string "password", limit: 128
    t.string "salt", limit: 128
    t.string "secret_question"
    t.string "secret_answer"
    t.integer "creator", null: true
    t.timestamp "date_created", default: -> { "current_timestamp" }, null: false
    t.integer "changed_by"
    t.datetime "date_changed"
    t.integer "person_id"
    t.integer "retired", limit: 1, default: 0, null: false
    t.integer "retired_by"
    t.datetime "date_retired"
    t.string "retire_reason"
    t.string "uuid", limit: 38, null: false
    t.string "authentication_token"
    t.datetime "token_expiry_time"
    t.datetime "deactivated_on"
    t.index ["changed_by"], name: "user_who_changed_user"
    t.index ["creator"], name: "user_creator"
    t.index ["person_id"], name: "person_id_for_user"
    t.index ["retired_by"], name: "user_who_retired_this_user"
  end

  add_foreign_key "concept", "concept_class", column: "class_id", primary_key: "concept_class_id", name: "concept_classes"
  add_foreign_key "concept", "concept_datatype", column: "datatype_id", primary_key: "concept_datatype_id", name: "concept_datatypes"
  add_foreign_key "concept", "users", column: "changed_by", primary_key: "user_id", name: "user_who_changed_concept"
  add_foreign_key "concept", "users", column: "creator", primary_key: "user_id", name: "concept_creator"
  add_foreign_key "concept", "users", column: "retired_by", primary_key: "user_id", name: "user_who_retired_concept"
  add_foreign_key "concept_class", "users", column: "creator", primary_key: "user_id", name: "concept_class_creator"
  add_foreign_key "concept_class", "users", column: "retired_by", primary_key: "user_id", name: "user_who_retired_concept_class"
  add_foreign_key "concept_complex", "concept", primary_key: "concept_id", name: "concept_attributes"
  add_foreign_key "concept_datatype", "users", column: "creator", primary_key: "user_id", name: "concept_datatype_creator"
  add_foreign_key "concept_datatype", "users", column: "retired_by", primary_key: "user_id", name: "user_who_retired_concept_datatype"
  add_foreign_key "concept_name", "concept", primary_key: "concept_id", name: "name_for_concept"
  add_foreign_key "concept_name", "users", column: "creator", primary_key: "user_id", name: "user_who_created_name"
  add_foreign_key "concept_name", "users", column: "voided_by", primary_key: "user_id", name: "user_who_voided_this_name"
  add_foreign_key "concept_numeric", "concept", primary_key: "concept_id", name: "numeric_attributes"
  add_foreign_key "concept_set", "concept", column: "concept_set", primary_key: "concept_id", name: "has_a"
  add_foreign_key "concept_set", "concept", primary_key: "concept_id", name: "is_a"
  add_foreign_key "concept_set", "users", column: "creator", primary_key: "user_id", name: "user_who_created"
  add_foreign_key "drug", "concept", column: "dosage_form", primary_key: "concept_id", name: "dosage_form_concept"
  add_foreign_key "drug", "concept", column: "route", primary_key: "concept_id", name: "route_concept"
  add_foreign_key "drug", "concept", primary_key: "concept_id", name: "primary_drug_concept"
  add_foreign_key "drug", "users", column: "creator", primary_key: "user_id", name: "drug_creator"
  add_foreign_key "drug", "users", column: "retired_by", primary_key: "user_id", name: "drug_retired_by"
  add_foreign_key "drug_order", "drug", column: "drug_inventory_id", primary_key: "drug_id", name: "inventory_item"
  add_foreign_key "drug_order", "orders", primary_key: "order_id", name: "extends_order"
  add_foreign_key "encounter", "encounter_type", column: "encounter_type", primary_key: "encounter_type_id", name: "encounter_type_id"
  add_foreign_key "encounter", "form", primary_key: "form_id", name: "encounter_form"
  add_foreign_key "encounter", "location", primary_key: "location_id", name: "encounter_location"
  add_foreign_key "encounter", "patient", primary_key: "patient_id", name: "encounter_patient", on_update: :cascade
  add_foreign_key "encounter", "person", column: "provider_id", primary_key: "person_id", name: "encounter_provider"
  add_foreign_key "encounter", "users", column: "changed_by", primary_key: "user_id", name: "encounter_changed_by"
  add_foreign_key "encounter", "users", column: "creator", primary_key: "user_id", name: "encounter_ibfk_1"
  add_foreign_key "encounter", "users", column: "voided_by", primary_key: "user_id", name: "user_who_voided_encounter"
  add_foreign_key "encounter_type", "users", column: "creator", primary_key: "user_id", name: "user_who_created_type"
  add_foreign_key "encounter_type", "users", column: "retired_by", primary_key: "user_id", name: "user_who_retired_encounter_type"
  add_foreign_key "location", "location", column: "parent_location", primary_key: "location_id", name: "parent_location"
  add_foreign_key "location", "location_type", primary_key: "location_type_id", name: "location_type"
  add_foreign_key "location", "users", column: "creator", primary_key: "user_id", name: "user_who_created_location"
  add_foreign_key "location", "users", column: "retired_by", primary_key: "user_id", name: "user_who_retired_location"
  add_foreign_key "location_tag", "users", column: "creator", primary_key: "user_id", name: "location_tag_creator"
  add_foreign_key "location_tag", "users", column: "retired_by", primary_key: "user_id", name: "location_tag_retired_by"
  add_foreign_key "location_tag_map", "location", primary_key: "location_id", name: "location_tag_map_location"
  add_foreign_key "location_tag_map", "location_tag", primary_key: "location_tag_id", name: "location_tag_map_tag"
  add_foreign_key "obs", "concept", column: "value_coded", primary_key: "concept_id", name: "answer_concept"
  add_foreign_key "obs", "concept", primary_key: "concept_id", name: "obs_concept"
  add_foreign_key "obs", "concept_name", column: "value_coded_name_id", primary_key: "concept_name_id", name: "obs_name_of_coded_value"
  add_foreign_key "obs", "drug", column: "value_drug", primary_key: "drug_id", name: "answer_concept_drug"
  add_foreign_key "obs", "encounter", primary_key: "encounter_id", name: "encounter_observations"
  add_foreign_key "obs", "location", primary_key: "location_id", name: "obs_location"
  add_foreign_key "obs", "obs", column: "obs_group_id", primary_key: "obs_id", name: "obs_grouping_id"
  add_foreign_key "obs", "orders", primary_key: "order_id", name: "obs_order"
  add_foreign_key "obs", "person", primary_key: "person_id", name: "person_obs", on_update: :cascade
  add_foreign_key "obs", "users", column: "creator", primary_key: "user_id", name: "obs_enterer"
  add_foreign_key "obs", "users", column: "voided_by", primary_key: "user_id", name: "user_who_voided_obs"
  add_foreign_key "order_type", "users", column: "creator", primary_key: "user_id", name: "type_created_by"
  add_foreign_key "order_type", "users", column: "retired_by", primary_key: "user_id", name: "user_who_retired_order_type"
  add_foreign_key "orders", "concept", column: "discontinued_reason", primary_key: "concept_id", name: "discontinued_because"
  add_foreign_key "orders", "encounter", primary_key: "encounter_id", name: "orders_in_encounter"
  add_foreign_key "orders", "obs", column: "obs_id", primary_key: "obs_id", name: "obs_for_order"
  add_foreign_key "orders", "order_type", primary_key: "order_type_id", name: "type_of_order"
  add_foreign_key "orders", "patient", primary_key: "patient_id", name: "order_for_patient", on_update: :cascade
  add_foreign_key "orders", "users", column: "creator", primary_key: "user_id", name: "order_creator"
  add_foreign_key "orders", "users", column: "discontinued_by", primary_key: "user_id", name: "user_who_discontinued_order"
  add_foreign_key "orders", "users", column: "orderer", primary_key: "user_id", name: "orderer_not_drug"
  add_foreign_key "orders", "users", column: "voided_by", primary_key: "user_id", name: "user_who_voided_order"
  add_foreign_key "patient", "person", column: "patient_id", primary_key: "person_id", name: "person_id_for_patient", on_update: :cascade
  add_foreign_key "patient", "tribe", column: "tribe", primary_key: "tribe_id", name: "belongs_to_tribe"
  add_foreign_key "patient", "users", column: "changed_by", primary_key: "user_id", name: "user_who_changed_pat"
  add_foreign_key "patient", "users", column: "creator", primary_key: "user_id", name: "user_who_created_patient"
  add_foreign_key "patient", "users", column: "voided_by", primary_key: "user_id", name: "user_who_voided_patient"
  add_foreign_key "patient_identifier", "location", primary_key: "location_id", name: "patient_identifier_ibfk_2"
  add_foreign_key "patient_identifier", "patient", primary_key: "patient_id", name: "identifies_patient"
  add_foreign_key "patient_identifier", "patient_identifier_type", column: "identifier_type", primary_key: "patient_identifier_type_id", name: "defines_identifier_type"
  add_foreign_key "patient_identifier", "users", column: "creator", primary_key: "user_id", name: "identifier_creator"
  add_foreign_key "patient_identifier", "users", column: "voided_by", primary_key: "user_id", name: "identifier_voider"
  add_foreign_key "patient_identifier_type", "users", column: "creator", primary_key: "user_id", name: "type_creator"
  add_foreign_key "patient_identifier_type", "users", column: "retired_by", primary_key: "user_id", name: "user_who_retired_patient_identifier_type"
  add_foreign_key "patient_program", "patient", primary_key: "patient_id", name: "patient_in_program", on_update: :cascade
  add_foreign_key "patient_program", "program", primary_key: "program_id", name: "program_for_patient"
  add_foreign_key "patient_program", "users", column: "changed_by", primary_key: "user_id", name: "user_who_changed"
  add_foreign_key "patient_program", "users", column: "creator", primary_key: "user_id", name: "patient_program_creator"
  add_foreign_key "patient_program", "users", column: "voided_by", primary_key: "user_id", name: "user_who_voided_patient_program"
  add_foreign_key "patient_state", "patient_program", primary_key: "patient_program_id", name: "patient_program_for_state"
  add_foreign_key "patient_state", "program_workflow_state", column: "state", primary_key: "program_workflow_state_id", name: "state_for_patient"
  add_foreign_key "patient_state", "users", column: "changed_by", primary_key: "user_id", name: "patient_state_changer"
  add_foreign_key "patient_state", "users", column: "creator", primary_key: "user_id", name: "patient_state_creator"
  add_foreign_key "patient_state", "users", column: "voided_by", primary_key: "user_id", name: "patient_state_voider"
  add_foreign_key "person", "concept", column: "cause_of_death", primary_key: "concept_id", name: "person_died_because"
  add_foreign_key "person", "users", column: "changed_by", primary_key: "user_id", name: "user_who_changed_person"
  add_foreign_key "person", "users", column: "creator", primary_key: "user_id", name: "user_who_created_person"
  add_foreign_key "person", "users", column: "voided_by", primary_key: "user_id", name: "user_who_voided_person"
  add_foreign_key "person_address", "person", primary_key: "person_id", name: "address_for_person", on_update: :cascade
  add_foreign_key "person_address", "users", column: "creator", primary_key: "user_id", name: "patient_address_creator"
  add_foreign_key "person_address", "users", column: "voided_by", primary_key: "user_id", name: "patient_address_void"
  add_foreign_key "person_attribute", "person", primary_key: "person_id", name: "identifies_person"
  add_foreign_key "person_attribute", "person_attribute_type", primary_key: "person_attribute_type_id", name: "defines_attribute_type"
  add_foreign_key "person_attribute", "users", column: "changed_by", primary_key: "user_id", name: "attribute_changer"
  add_foreign_key "person_attribute", "users", column: "creator", primary_key: "user_id", name: "attribute_creator"
  add_foreign_key "person_attribute", "users", column: "voided_by", primary_key: "user_id", name: "attribute_voider"
  add_foreign_key "person_attribute_type", "privilege", column: "edit_privilege", primary_key: "privilege", name: "privilege_which_can_edit"
  add_foreign_key "person_attribute_type", "users", column: "changed_by", primary_key: "user_id", name: "attribute_type_changer"
  add_foreign_key "person_attribute_type", "users", column: "creator", primary_key: "user_id", name: "attribute_type_creator"
  add_foreign_key "person_attribute_type", "users", column: "retired_by", primary_key: "user_id", name: "user_who_retired_person_attribute_type"
  add_foreign_key "person_name", "person", primary_key: "person_id", name: "name for person", on_update: :cascade
  add_foreign_key "person_name", "users", column: "creator", primary_key: "user_id", name: "user_who_made_name"
  add_foreign_key "person_name", "users", column: "voided_by", primary_key: "user_id", name: "user_who_voided_name"
  add_foreign_key "person_name_code", "person_name", primary_key: "person_name_id", name: "code for name", on_update: :cascade
  add_foreign_key "program", "concept", primary_key: "concept_id", name: "program_concept"
  add_foreign_key "program", "users", column: "changed_by", primary_key: "user_id", name: "user_who_changed_program"
  add_foreign_key "program", "users", column: "creator", primary_key: "user_id", name: "program_creator"
  add_foreign_key "program_workflow", "concept", primary_key: "concept_id", name: "workflow_concept"
  add_foreign_key "program_workflow", "program", primary_key: "program_id", name: "program_for_workflow"
  add_foreign_key "program_workflow", "users", column: "changed_by", primary_key: "user_id", name: "workflow_changed_by"
  add_foreign_key "program_workflow", "users", column: "creator", primary_key: "user_id", name: "workflow_creator"
  add_foreign_key "program_workflow_state", "concept", primary_key: "concept_id", name: "state_concept"
  add_foreign_key "program_workflow_state", "program_workflow", primary_key: "program_workflow_id", name: "workflow_for_state"
  add_foreign_key "program_workflow_state", "users", column: "changed_by", primary_key: "user_id", name: "state_changed_by"
  add_foreign_key "program_workflow_state", "users", column: "creator", primary_key: "user_id", name: "state_creator"
  add_foreign_key "region", "users", column: "creator", primary_key: "user_id", name: "user_who_created_region"
  add_foreign_key "region", "users", column: "retired_by", primary_key: "user_id", name: "user_who_retired_region"
  add_foreign_key "relationship", "person", column: "person_a", primary_key: "person_id", name: "person_a", on_update: :cascade
  add_foreign_key "relationship", "person", column: "person_b", primary_key: "person_id", name: "person_b", on_update: :cascade
  add_foreign_key "relationship", "relationship_type", column: "relationship", primary_key: "relationship_type_id", name: "relationship_type_id"
  add_foreign_key "relationship", "users", column: "creator", primary_key: "user_id", name: "relation_creator"
  add_foreign_key "relationship", "users", column: "voided_by", primary_key: "user_id", name: "relation_voider"
  add_foreign_key "relationship_type", "users", column: "creator", primary_key: "user_id", name: "user_who_created_rel"
  add_foreign_key "relationship_type", "users", column: "retired_by", primary_key: "user_id", name: "user_who_retired_relationship_type"
  add_foreign_key "role_privilege", "privilege", column: "privilege", primary_key: "privilege", name: "privilege_definitons"
  add_foreign_key "role_privilege", "role", column: "role", primary_key: "role", name: "role_privilege"
  add_foreign_key "role_role", "role", column: "child_role", primary_key: "role", name: "inherited_role"
  add_foreign_key "role_role", "role", column: "parent_role", primary_key: "role", name: "parent_role"
  add_foreign_key "user_property", "users", primary_key: "user_id", name: "user_property"
  add_foreign_key "user_role", "role", column: "role", primary_key: "role", name: "role_definitions"
  add_foreign_key "user_role", "users", primary_key: "user_id", name: "user_role"
  add_foreign_key "users", "person", primary_key: "person_id", name: "person_id_for_user"
  add_foreign_key "users", "users", column: "changed_by", primary_key: "user_id", name: "user_who_changed_user"
  add_foreign_key "users", "users", column: "creator", primary_key: "user_id", name: "user_creator"
  add_foreign_key "users", "users", column: "retired_by", primary_key: "user_id", name: "user_who_retired_this_user"
end
