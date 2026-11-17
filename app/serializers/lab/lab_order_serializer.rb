# frozen_string_literal: true

require_relative '../../services/lab/order_location_resolver'

module Lab
  module LabOrderSerializer
    def self.serialize_order(order, tests: nil, requesting_clinician: nil, reason_for_test: nil, target_lab: nil, comment_to_fulfiller: nil)
      tests ||= [1, true].include?(order.voided) ? voided_tests(order) : order_tests(order)
      requesting_clinician ||= order_observation(order, Lab::Metadata::REQUESTING_CLINICIAN_CONCEPT_NAME)
      comment_to_fulfiller ||= order_observation(order, Lab::Metadata::COMMENT_TO_FULFILLER_CONCEPT_NAME)
      reason_for_test ||= order_observation(order, Lab::Metadata::REASON_FOR_TEST_CONCEPT_NAME)

      encounter = Encounter.unscoped.find_by_encounter_id(order.encounter_id)
      location = Lab::OrderLocationResolver.location_for_order(order, fallback_location_id: encounter&.location_id)
      target_lab = target_lab&.value_text ||
                   order_observation(order, Lab::Metadata::TARGET_LAB_CONCEPT_NAME)&.value_text ||
                   location&.name ||
                   Location.current_health_center&.name
      program = Program.find_by_program_id(encounter&.program_id)

      ActiveSupport::HashWithIndifferentAccess.new(
        {
          id: order.order_id,
          order_type_id: order.order_type_id,
          order_id: order.order_id, # Deprecated: Link to :id
          encounter_id: order.encounter_id,
          **(Encounter.column_names.include?('visit_id') ? { visit_id: encounter&.visit_id } : {}),
          order_date: order.start_date,
          location_id: location&.location_id,
          program_id: encounter&.program_id,
          program_name: program&.name,
          patient_id: order.patient_id,
          accession_number: order.accession_number,
          specimen: {
            concept_id: order.concept_id,
            name: concept_name(order.concept_id)
          },
          requesting_clinician: requesting_clinician&.value_text,
          target_lab: target_lab,
          comment_to_fulfiller: comment_to_fulfiller.respond_to?(:value_text) ? comment_to_fulfiller.value_text : comment_to_fulfiller,
          reason_for_test: {
            concept_id: reason_for_test&.value_coded,
            name: concept_name(reason_for_test&.value_coded)
          },
          delivery_mode: order&.lims_acknowledgement_status&.acknowledgement_type,
          order_status: latest_order_status(order),
          order_status_trail: serialize_order_status_trail(order),
          tests: tests.map do |test|
            result_obs = test.result

            {
              id: test.obs_id,
              concept_id: test.value_coded,
              uuid: test.uuid,
              name: concept_name(test.value_coded),
              test_method: test_method(order, test.value_coded),
              result: result_obs && ResultSerializer.serialize(result_obs),
              test_status: latest_test_status(test),
              test_status_trail: serialize_test_status_trail(test)
            }
          end
        }
      )
    end

    def self.test_method(order, _concept_id)
      obs = ::Observation
            .unscoped
            .select(:value_coded)
            .where(concept_id: ConceptName.find_by_name(Metadata::TEST_METHOD_CONCEPT_NAME).concept_id, order_id: order.order_id)
            .where(voided: 0)
            .first
      {
        concept_id: obs&.value_coded,
        name: ConceptName.find_by_concept_id(obs&.value_coded)&.name
      }
    end

    def self.concept_name(concept_id)
      return concept_id unless concept_id

      ::ConceptAttribute.find_by(concept_id:, attribute_type: ConceptAttributeType.test_catalogue_name)&.value_reference ||
        ::ConceptName.find_by_concept_id(concept_id)&.name
    end

    def self.order_tests(order)
      concept = ConceptName.where(name: Lab::Metadata::TEST_TYPE_CONCEPT_NAME)
                           .select(:concept_id)
      LabTest.unscoped.where(concept_id: concept, order_id: order.order_id, voided: 0)
    end

    def self.voided_tests(order)
      concept = ConceptName.where(name: Lab::Metadata::TEST_TYPE_CONCEPT_NAME)
                           .select(:concept_id)
      LabTest.unscoped.where(concept_id: concept, order_id: order.order_id, voided: 1)
    end

    def self.order_observation(order, concept_name)
      concept = ConceptName.where(name: concept_name).select(:concept_id)
      Observation.unscoped.find_by(order_id: order.order_id, concept_id: concept, voided: 0)
    end

    # The trail methods load the whole association (a handful of rows per
    # order/test) and the "latest" methods take the last loaded row. Calling
    # `.last` on an unloaded association instead issues
    # `ORDER BY obs_datetime DESC, obs_id DESC LIMIT 1`, and with LIMIT 1 MySQL
    # may walk an obs_datetime index (obs_datetime_idx / idx_obs_adherence_lookup)
    # backwards across the whole obs table rather than use obs_order. Loading
    # also caches the rows on the record, so the trail and the latest status
    # share a single query.
    def self.latest_order_status(order)
      serialize_status_obs(order.status_trail_observations.to_a.last)
    end

    def self.serialize_order_status_trail(order)
      order.status_trail_observations.to_a.map { |obs| serialize_status_obs(obs) }
    end

    def self.latest_test_status(test)
      serialize_status_obs(test.status_trail_observations.to_a.last)
    end

    def self.serialize_test_status_trail(test)
      test.status_trail_observations.to_a.map { |obs| serialize_status_obs(obs) }
    end

    def self.serialize_status_obs(obs)
      return nil unless obs

      {
        status_id: 0, # status_id not used with text values
        status: obs.value_text,
        timestamp: obs.obs_datetime,
        updated_by: parse_comments_json(obs.comments)
      }
    end

    # Helper to parse updated_by from obs comments field
    def self.parse_comments_json(comments)
      return {} if comments.blank?

      JSON.parse(comments)
    rescue JSON::ParserError
      {}
    end
  end
end
