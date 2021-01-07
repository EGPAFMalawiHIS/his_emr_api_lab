# frozen_string_literal: true


module Lab
  class OrdersController < ApplicationController
    def create
      order_params_list = params.require(:orders)
      orders = order_params_list.map { |order_params| OrdersService.order_test(order_params) }

      render json: orders, status: :created
    end

    def index
      filters = params.permit(%i[pending_results patient_id accession_number date])

      render json: OrdersSearchService.find_orders(filters)
    end
  end
end
