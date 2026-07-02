# frozen_string_literal: true

require_relative 'metadata'

module Lab
  # Resolves the location that should be used for lab sync records.
  #
  # LIMS workers often run as lab_daemon, whose current location can differ from
  # the clinician/order location. Order-linked observations are the most reliable
  # source because they carry the location where the order was created.
  module OrderLocationResolver
    ORDER_OBSERVATION_CONCEPT_NAMES = [
      Lab::Metadata::TEST_TYPE_CONCEPT_NAME,
      Lab::Metadata::TEST_METHOD_CONCEPT_NAME,
      Lab::Metadata::REQUESTING_CLINICIAN_CONCEPT_NAME,
      Lab::Metadata::REASON_FOR_TEST_CONCEPT_NAME,
      Lab::Metadata::TARGET_LAB_CONCEPT_NAME,
      Lab::Metadata::COMMENT_TO_FULFILLER_CONCEPT_NAME
    ].freeze

    module_function

    def location_for_order(order, fallback_location_id: nil, facility_name: nil)
      observation_location_for_order(order) ||
        location_by_id(fallback_location_id || record_location_id(order)) ||
        encounter_location_for_order(order) ||
        creator_location_for_order(order) ||
        location_from_name(facility_name) ||
        Location.current_health_center
    end

    def location_id_for_order(order, fallback_location_id: nil, facility_name: nil)
      location_for_order(order, fallback_location_id:, facility_name:)&.location_id
    end

    def location_for_order_id(order_id, fallback_location_id: nil, facility_name: nil)
      order = Lab::LabOrder.unscoped.find_by(order_id:)

      location_for_order(order, fallback_location_id:, facility_name:)
    end

    def location_id_for_order_id(order_id, fallback_location_id: nil, facility_name: nil)
      location_for_order_id(order_id, fallback_location_id:, facility_name:)&.location_id
    end

    def location_for_test(test)
      location_for_order_id(record_order_id(test), fallback_location_id: record_location_id(test)) ||
        location_by_id(record_location_id(test)) ||
        location_by_id(encounter_location_id_for_record(test))
    end

    def location_id_for_test(test)
      location_for_test(test)&.location_id
    end

    def location_from_name(name)
      name = name.to_s.strip
      return nil if name.blank? || name.casecmp?('Unknown') || name.casecmp?('not_assigned')

      Location.unscoped.where('LOWER(name) = ?', name.downcase).first
    end

    def location_by_id(location_id)
      return nil if location_id.blank? || location_id.to_i.zero?

      Location.unscoped.find_by(location_id:)
    end

    def observation_location_for_order(order)
      order_id = record_order_id(order)
      return nil if order_id.blank?

      location_id = prioritized_order_observations(order_id).first&.location_id
      location_by_id(location_id)
    end

    def encounter_location_for_order(order)
      location_by_id(encounter_location_id_for_record(order))
    end

    def creator_location_for_order(order)
      creator_id = record_creator_id(order)
      return nil if creator_id.blank?

      user = User.unscoped.find_by(user_id: creator_id)
      location_by_id(user&.location_id)
    end

    def prioritized_order_observations(order_id)
      scope = Observation.unscoped.where(order_id:, voided: 0).where.not(location_id: [nil, 0])
      concept_ids = order_location_concept_ids
      return scope.order(:date_created, :obs_id) if concept_ids.blank?

      quoted_ids = concept_ids.map(&:to_i).join(',')
      scope.order(Arel.sql("CASE WHEN concept_id IN (#{quoted_ids}) THEN 0 ELSE 1 END, date_created ASC, obs_id ASC"))
    end

    def order_location_concept_ids
      ConceptName.where(name: ORDER_OBSERVATION_CONCEPT_NAMES).pluck(:concept_id)
    end

    def encounter_location_id_for_record(record)
      encounter_id = record_encounter_id(record)
      return nil if encounter_id.blank?

      Encounter.unscoped.find_by(encounter_id:)&.location_id
    end

    def record_order_id(record)
      return nil unless record
      return record.order_id if record.respond_to?(:order_id)

      value_from_hash(record, :order_id) || value_from_hash(record, :id)
    end

    def record_encounter_id(record)
      return nil unless record
      return record.encounter_id if record.respond_to?(:encounter_id)

      value_from_hash(record, :encounter_id)
    end

    def record_location_id(record)
      return nil unless record
      return record.location_id if record.respond_to?(:location_id)

      value_from_hash(record, :location_id)
    end

    def record_creator_id(record)
      return nil unless record
      return record.creator if record.respond_to?(:creator)

      value_from_hash(record, :creator)
    end

    def value_from_hash(record, key)
      return nil unless record.respond_to?(:[])

      record[key] || record[key.to_s]
    end
  end
end
