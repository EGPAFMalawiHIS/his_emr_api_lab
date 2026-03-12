# frozen_string_literal: true

# This migration creates concepts for lab order and test status tracking using obs table
# Status values are stored as text (value_text), not coded values
class CreateLabStatusConcepts < ActiveRecord::Migration[5.2]
  def up
    ActiveRecord::Base.transaction do
      # Find concept class and datatype
      concept_class = ConceptClass.find_by(name: 'Finding') || ConceptClass.find_by(name: 'Misc')
      text_datatype = ConceptDatatype.find_by(name: 'Text')

      # Create Lab Order Status concept (stores status as value_text)
      unless ConceptName.exists?(name: 'Lab Order Status')
        order_status_concept = create_concept(
          name: 'Lab Order Status',
          class_id: concept_class.id,
          datatype_id: text_datatype.id,
          is_set: 0
        )
        puts "Created 'Lab Order Status' concept with ID: #{order_status_concept.concept_id}"
      end

      # Create Lab Test Status concept (stores status as value_text)
      unless ConceptName.exists?(name: 'Lab Test Status')
        test_status_concept = create_concept(
          name: 'Lab Test Status',
          class_id: concept_class.id,
          datatype_id: text_datatype.id,
          is_set: 0
        )
        puts "Created 'Lab Test Status' concept with ID: #{test_status_concept.concept_id}"
      end

      puts 'Lab status concepts created successfully'
    end
  end

  def down
    ActiveRecord::Base.transaction do
      # Remove concepts
      concepts_to_remove = ['Lab Order Status', 'Lab Test Status']

      concepts_to_remove.each do |name|
        concept = ConceptName.find_by(name: name)&.concept
        next unless concept

        ConceptName.where(concept: concept).destroy_all
        concept.destroy
      end
    end
  end

  private

  def create_concept(name:, class_id:, datatype_id:, is_set:)
    concept = Concept.create!(
      class_id: class_id,
      datatype_id: datatype_id,
      short_name: name,
      retired: 0,
      is_set: is_set,
      creator: 1,
      date_created: Time.current,
      uuid: SecureRandom.uuid
    )

    ConceptName.create!(
      concept: concept,
      name: name,
      locale: 'en',
      locale_preferred: 1,
      concept_name_type: 'FULLY_SPECIFIED',
      creator: 1,
      date_created: Time.current,
      uuid: SecureRandom.uuid
    )

    concept
  end
end
