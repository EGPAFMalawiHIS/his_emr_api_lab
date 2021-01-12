# frozen_string_literal: true

module Lab
  class ResultsController < ApplicationController
    def create
      result_params = params.require(:result)
                            .permit(%i[encounter_id modifier value date])

      test = Lab::LabTest.find(params[:test_id])
      result = Lab::ResultsService.create_result(test, result_params)

      render json: result, status: :created
    end
  end
end
