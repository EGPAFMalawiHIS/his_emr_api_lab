# frozen_string_literal: true

require_relative 'reasons_for_test_loader'
require_relative 'specimens_loader'
require_relative 'test_result_indicators_loader'

module Lab
  module Loaders
    module MetadataLoader
      def self.load
        SpecimensLoader.load
        TestResultIndicatorsLoader.load
        ReasonsForTestLoader.load
      end
    end
  end
end

Lab::Loaders::MetadataLoader.load
