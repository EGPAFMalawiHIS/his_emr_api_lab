# frozen_string_literal: true

require_relative './order_dto'

module Lab
  module Lims
    ##
    # Manage LIMS orders that failed to import
    module FailedImports
      class << self
        ##
        # Retrieve all imports that failed
        def failed_imports(start_id = 0, limit = 20)
          Lab::LimsFailedImport.where('id >= ?', start_id).limit(limit)
        end

        ##
        # Forcefully imports a failed import into a patient
        def force_import(failed_import_id, _patient_id)
          failed_import = Lab::LimsFailedImport.find(failed_import_id)
          order_dto = Lab::Lims::OrderDTO.new(lims_api.find_order(failed_import.lims_id))
          byebug
        end

        private

        def lims_api
          @lims_api ||= Lab::Lims::Api.new
        end
      end
    end
  end
end
