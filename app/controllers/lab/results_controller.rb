# frozen_string_literal: true

module Lab
  class ResultsController < ApplicationController
    def create
      result_params = params.require(:result)
                            .permit(%i[encounter_id modifier value date])

      result = Lab::ResultsService.create_result(params[:test_id], result_params)

      render json: result, status: :created
    end
  end
end
