# frozen_string_literal: true

module Lab
  module Lims
    ##
    # Various helper methods for modules in the Lims namespaces...
    module Utils
      def logger
        Rails.logger
      end
    end
  end
end
