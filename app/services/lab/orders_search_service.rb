# frozen_string_literal: true

module Lab
  # Search Lab orders.
  module OrdersSearchService
    class << self
      def find_orders(filters)
        date = filters.delete(:date)
        pending_results = filters.delete(:pending_results)&.casecmp?('true') || false

        orders = Lab::LabOrder.prefetch_relationships
                              .where(filters)
                              .order(start_date: :desc)
        orders = filter_orders_by_date(orders, date) if date
        orders = filter_orders_with_results(orders) if pending_results

        orders.map { |order| Lab::LabOrderSerializer.serialize_order(order) }
      end

      def filter_orders_by_date(orders, date)
        start_date = date.to_date
        end_date = start_date + 1.day

        orders.where('start_date >= DATE(?) AND start_date < DATE(?)', start_date, end_date)
      end

      def filter_orders_with_results(orders)
        lab_test_concept = ConceptName.where(name: Lab::LabOrder::LAB_TEST_RESULT_CONCEPT_NAME)
                                      .select(:concept_id)
        lab_results = Observation.where(concept: lab_test_concept)
                                 .where.not(obs_group_id: nil)
                                 .select(:obs_group_id)

        # Select only orders having specimens missing results.
        orders.left_joins(:specimens)
              .where.not(obs: { obs_id: lab_results })
      end
    end
  end
end
