# frozen_string_literal: true

module Lab
  # A read-only repository of sort for all lab-centric concepts.
  module ConceptsService
    def self.test_types(name: nil, specimen_type: nil)
      test_types = ConceptSet.find_members_by_name(LabOrder::TEST_TYPE_CONCEPT_NAME)
      test_types = test_types.filter_members(name: name) if name

      unless specimen_type
        return test_types.joins('INNER JOIN concept_name ON concept_set.concept_id = concept_name.concept_id')
                         .select('concept_name.name, concept_name.concept_id')
                         .group('concept_name.concept_id')
      end

      # Filter out only those test types that have the specified specimen
      # type.
      specimen_types = ConceptSet.find_members_by_name(LabOrder::SPECIMEN_TYPE_CONCEPT_NAME)
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
      specimen_types = ConceptSet.find_members_by_name(LabOrder::SPECIMEN_TYPE_CONCEPT_NAME)
      specimen_types = specimen_types.filter_members(name: name) if name

      unless test_type
        return specimen_types.select('concept_name.concept_id, concept_name.name')
                             .joins('INNER JOIN concept_name ON concept_name.concept_id = concept_set.concept_id')
                             .group('concept_name.concept_id')
      end

      # Retrieve only those specimen types that belong to concept
      # set of the selected test_type
      test_types = ConceptSet.find_members_by_name(LabOrder::TEST_TYPE_CONCEPT_NAME)
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
  end
end
