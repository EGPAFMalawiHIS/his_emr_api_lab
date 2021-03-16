# frozen_string_literal: true

require_relative 'specimens_loader'
require_relative 'test_measures_loader'

module Lab
  module Loaders
    module MetadataLoader
      def self.load
        SpecimensLoader.load
        TestMeasuresLoader.load
      end
    end
  end
end

Lab::Loaders::MetadataLoader.load
