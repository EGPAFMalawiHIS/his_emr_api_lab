# frozen_string_literal: true

module Lab
  class LabelsController < ApplicationController
    skip_before_action :authenticate

    def print_order_label
      order_id = params.require(:order_id)
      print_copies = params[:number_of_copies].to_i if params[:number_of_copies].present?
      render_zpl(LabellingService::OrderLabel.new(order_id).print(
          params[:use_small_specimen_label] == 'true', 
          print_copies        
        )
      )
    end
  end
end
