# frozen_string_literal: true

module Lab
  # A read-only repository of sort for all lab-centric concepts.
  module ConceptsService
    def self.test_types(name: nil, specimen_type: nil)
      test_types = ConceptSet.find_members_by_name(Lab::Metadata::TEST_TYPE_CONCEPT_NAME)
      test_types = test_types.filter_members(name: name) if name

      unless specimen_type
        return test_types.joins('INNER JOIN concept_name ON concept_set.concept_id = concept_name.concept_id')
                         .select('concept_name.name, concept_name.concept_id')
                         .group('concept_name.concept_id')
      end

      # Filter out only those test types that have the specified specimen
      # type.
      specimen_types = ConceptSet.find_members_by_name(Lab::Metadata::SPECIMEN_TYPE_CONCEPT_NAME)
                                 .filter_members(name: specimen_type)
                                 .select(:concept_id)

      concept_set = ConceptSet.where(
        concept_id: specimen_types,
        concept_set: test_types.select(:concept_id)
      )

      concept_set.joins('INNER JOIN concept_name ON concept_set.concept_set = concept_name.concept_id')
                 .select('concept_name.concept_id, concept_name.name')
                 .group('concept_name.concept_id')
    end

    def self.specimen_types(name: nil, test_type: nil)
      specimen_types = ConceptSet.find_members_by_name(Lab::Metadata::SPECIMEN_TYPE_CONCEPT_NAME)
      specimen_types = specimen_types.filter_members(name: name) if name

      unless test_type
        return specimen_types.select('concept_name.concept_id, concept_name.name')
                             .joins('INNER JOIN concept_name ON concept_name.concept_id = concept_set.concept_id')
                             .group('concept_name.concept_id')
      end

      # Retrieve only those specimen types that belong to concept
      # set of the selected test_type
      test_types = ConceptSet.find_members_by_name(Lab::Metadata::TEST_TYPE_CONCEPT_NAME)
                             .filter_members(name: test_type)
                             .select(:concept_id)

      concept_set = ConceptSet.where(
        concept_id: specimen_types.select(:concept_id),
        concept_set: test_types
      )

      concept_set.select('concept_name.concept_id, concept_name.name')
                 .joins('INNER JOIN concept_name ON concept_name.concept_id = concept_set.concept_id')
                 .group('concept_name.concept_id')
    end

    def self.test_result_indicators(test_type_id)
      # Verify that the specified test_type is indeed a test_type
      test_concept = ConceptSet.find_members_by_name(Lab::Metadata::TEST_TYPE_CONCEPT_NAME)
                               .where(concept_id: test_type_id)
                               .select(:concept_id)

      # Find all concepts in the chosen test type's concept_set
      test_concept_set_members = ConceptSet.where(concept_set: test_concept)
                                           .select(:concept_id)

      # From the members above, filter out only those concepts that are result indicators
      ConceptSet.find_members_by_name(Lab::Metadata::TEST_RESULT_INDICATOR_CONCEPT_NAME)
                .where(concept_id: test_concept_set_members)
                .joins('INNER JOIN concept_name AS measure ON measure.concept_id = concept_set.concept_id')
                .group(:concept_id)
                .select('measure.concept_id, measure.name')
    end
  end
end
