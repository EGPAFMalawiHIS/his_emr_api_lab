# frozen_string_literal: true

module Lab
  class LabelsController < ApplicationController
    skip_before_action :authenticate

    def print_order_label
      order_id = params.require(:order_id)

      render_zpl(LabellingService::OrderLabel.new(order_id).print)
    end
  end
end
