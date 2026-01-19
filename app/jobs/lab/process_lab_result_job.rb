# frozen_string_literal: true

module Lab
  ##
  # Push an order to LIMS.
  class ProcessLabResultJob < ApplicationJob
    queue_as :default
    def perform(results_obs_id, serializer, result_enter_by)
      results_obs = Lab::LabResult.find(results_obs_id)
      Lab::ResultsService.process_result_completion(results_obs, serializer, result_enter_by)
    end
  end
end