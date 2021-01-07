# frozen_string_literal: true

module Lab
  # Manage specimens belonging to an order
  #
  # /orders/:order_id/specimens[/:specimen_id]
  class OrderSpecimensController < ApplicationController
    # Add a specimen to an existing order
    def create
      order_params = params.require(:order_specimen)
                           .permit(specimens: %i[concept_id])

      order = OrdersService.update_order(params[:order_id], order_params)

      render json: order[:specimens], status: :created
    end
  end
end
