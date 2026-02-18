# frozen_string_literal: true

module Lab
  class VoidOrderJob < ApplicationJob
    queue_as :default

    def perform(order_id)
      Rails.logger.info("Voiding order ##{order_id} in LIMS")

      User.current = Lab::Lims::Utils.lab_user
      # Set location from order's encounter to ensure proper context
      order = Lab::LabOrder.unscoped.find(order_id)
      encounter = Encounter.unscoped.find_by(encounter_id: order.encounter_id)
      Location.current = Location.find(encounter.location_id) if encounter&.location_id
      Location.current ||= Location.find_by_name('ART clinic')

      worker = Lab::Lims::PushWorker.new(Lab::Lims::ApiFactory.create_api)
      worker.push_order(order)
    end
  end
end
