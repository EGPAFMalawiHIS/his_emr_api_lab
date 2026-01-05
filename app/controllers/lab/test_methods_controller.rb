# frozen_string_literal: true

module Lab
  class TestMethodsController < ApplicationController
    def index
      render json: ConceptsService.test_methods(params.require(:nlims_code))
    end
  end
end