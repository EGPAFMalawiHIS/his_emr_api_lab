# frozen_string_literal: true

module Lab
  # Search Lab orders.
  module OrdersSearchService
    class << self
      def find_orders(filters)
        date = filters.delete(:date)

        orders = Lab::LabOrder.prefetch_relationships
                              .where(filters)
                              .order(start_date: :desc)

        orders = filter_orders_by_date(orders, date) if date

        orders.map { |order| Lab::LabOrderSerializer.serialize_order(order) }
      end

      def filter_orders_by_date(orders, date)
        start_date = date.to_date
        end_date = start_date + 1.day

        orders.where('start_date >= DATE(?) AND start_date < DATE(?)', start_date, end_date)
      end
    end
  end
end
