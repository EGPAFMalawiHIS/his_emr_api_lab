# frozen_string_literal: true

module Lab
  # A read-only repository of sort for all lab-centric concepts.
  module ConceptsService
    def self.test_types(name: nil, specimen_type: nil)
      test_types = ConceptSet.find_members_by_name(Lab::Metadata::TEST_TYPE_CONCEPT_NAME)
      test_types = test_types.filter_members(name:) if name

      unless specimen_type
        return ActiveRecord::Base.connection.select_all <<~SQL
          SELECT ca.concept_id, ca.value_reference as name, ca2.value_reference as nlims_code
            FROM concept_attribute ca
          INNER JOIN concept_attribute ca2 ON ca.concept_id = ca2.concept_id
            AND ca2.attribute_type_id = #{ConceptAttributeType.nlims_code.concept_attribute_type_id}
          WHERE ca.attribute_type_id = #{ConceptAttributeType.test_catalogue_name.concept_attribute_type_id}
          AND ca.concept_id IN (#{test_types.select(:concept_id).to_sql})
          GROUP BY ca.concept_id
        SQL
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

      return ActiveRecord::Base.connection.select_all <<~SQL
        SELECT ca.concept_id, ca.value_reference as name, ca2.value_reference as nlims_code
          FROM concept_attribute ca
        INNER JOIN concept_attribute ca2 ON ca.concept_id = ca2.concept_id
          AND ca2.attribute_type_id = #{ConceptAttributeType.nlims_code.concept_attribute_type_id}
        WHERE ca.attribute_type_id = #{ConceptAttributeType.test_catalogue_name.concept_attribute_type_id}
        AND ca.concept_id IN (#{concept_set.select(:concept_id).to_sql})
        GROUP BY ca.concept_id
      SQL
    end

    def self.specimen_types(name: nil, test_type: nil)
      specimen_types = ConceptSet.find_members_by_name(Lab::Metadata::SPECIMEN_TYPE_CONCEPT_NAME)
      specimen_types = specimen_types.filter_members(name: name) if name

      unless test_type
        return ActiveRecord::Base.connection.select_all <<~SQL
          SELECT ca.concept_id, ca.value_reference as name, ca2.value_reference as nlims_code
            FROM concept_attribute ca
          INNER JOIN concept_attribute ca2 ON ca.concept_id = ca2.concept_id
            AND ca2.attribute_type_id = #{ConceptAttributeType.nlims_code.concept_attribute_type_id}
          WHERE ca.attribute_type_id = #{ConceptAttributeType.test_catalogue_name.concept_attribute_type_id}
          AND ca.concept_id IN (#{specimen_types.select(:concept_id).to_sql})
          GROUP BY ca.concept_id
        SQL
      end

      # Retrieve only those specimen types that belong to concept
      # set of the selected test_type
      test_types = ConceptSet.find_members_by_name(Lab::Metadata::TEST_TYPE_CONCEPT_NAME)
                             .filter_members(name: test_type&.strip)
                             .select(:concept_id)

      concept_set = ConceptSet.where(
        concept_id: specimen_types.select(:concept_id),
        concept_set: test_types
      )

      return ActiveRecord::Base.connection.select_all <<~SQL
        SELECT ca.concept_id, ca.value_reference as name, ca2.value_reference as nlims_code
          FROM concept_attribute ca
        INNER JOIN concept_attribute ca2 ON ca.concept_id = ca2.concept_id
          AND ca2.attribute_type_id = #{ConceptAttributeType.nlims_code.concept_attribute_type_id}
        WHERE ca.attribute_type_id = #{ConceptAttributeType.test_catalogue_name.concept_attribute_type_id}
        AND ca.concept_id IN (#{concept_set.pluck(:concept_id).push(0).join(',')})
        GROUP BY ca.concept_id
      SQL
    end

    def self.test_result_indicators(test_type_id)
      # Verify that the specified test_type is indeed a test_type
      test = ConceptSet.find_members_by_name(Lab::Metadata::TEST_TYPE_CONCEPT_NAME)
                       .where(concept_id: test_type_id)
                       .select(:concept_id)

      # From the members above, filter out only those concepts that are result indicators
      measures = ConceptSet.find_members_by_name(Lab::Metadata::TEST_RESULT_INDICATOR_CONCEPT_NAME)
                           .select(:concept_id)

      sets = ConceptSet.where(concept_set: measures, concept_id: test)

      return ActiveRecord::Base.connection.select_all <<~SQL
        SELECT ca.concept_id, ca.value_reference as name, ca2.value_reference as nlims_code
          FROM concept_attribute ca
          INNER JOIN concept_attribute ca2 ON ca.concept_id = ca2.concept_id
            AND ca2.attribute_type_id = #{ConceptAttributeType.nlims_code.concept_attribute_type_id}
          WHERE ca.attribute_type_id = #{ConceptAttributeType.test_catalogue_name.concept_attribute_type_id}
          AND ca.concept_id IN (#{sets.pluck(:concept_set).push(0).join(',')})
          GROUP BY ca.concept_id
      SQL
    end

    def self.reasons_for_test
      ConceptSet.find_members_by_name(Lab::Metadata::REASON_FOR_TEST_CONCEPT_NAME)
                .joins('INNER JOIN concept_name ON concept_name.concept_id = concept_set.concept_id')
                .select('concept_name.concept_id, concept_name.name')
                .map { |concept| { name: concept.name, concept_id: concept.concept_id } }
    end
  end
end
