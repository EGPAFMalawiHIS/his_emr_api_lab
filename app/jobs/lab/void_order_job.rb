# frozen_string_literal: true

module Lab
  class VoidOrderJob < ApplicationJob
    queue_as :default

    def perform(order_id)
      Rails.logger.info("Voiding order ##{order_id} in LIMS")

      User.current = Lab::Lims::Utils.lab_user
      Location.current = Location.find_by_name('ART clinic')

      lims_api = Lab::Lims::Api::RestApi.new
      worker = Lab::Lims::Worker.new(lims_api)
      worker.push_order(Lab::LabOrder.unscoped.find(order_id))
    end
  end
end
