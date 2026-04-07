# frozen_string_literal: true

module Lab
  ##
  # Push an order to LIMS.
  class ProcessLabResultJob < ApplicationJob
    queue_as :default
    def perform(results_obs_id, serializer, result_enter_by)
      Rails.logger.info("Lab::ProcessLabResultJob: Processing result completion for #{serializer}")
      # set location context for the job based on the order's encounter to ensure proper context for any operations performed in the job
      results_obs = Lab::LabResult.unscoped.find(results_obs_id)
      encounter = Encounter.unscoped.find_by(encounter_id: results_obs.encounter_id)
      Location.current = Location.find(encounter.location_id) if encounter&.location_id
      Lab::ResultsService.process_result_completion(results_obs, serializer, result_enter_by)

      # Publish notification that results have been processed
      ActiveSupport::Notifications.instrument(
        'lab.results_saved',
        patient_id: results_obs.person_id,
        order_id: results_obs.order_id,
        result_id: results_obs.obs_id,
        encounter_id: results_obs.encounter_id,
        timestamp: Time.current
      )
    end
  end
end
