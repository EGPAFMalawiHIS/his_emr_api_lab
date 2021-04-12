# frozen_string_literal: true

require 'cgi/util'

module Lab
  module Lims
    ##
    # Various helper methods for modules in the Lims namespaces...
    module Utils
      def logger
        Rails.logger
      end

      def structify(object)
        if object.is_a?(Hash)
          object.each_with_object(OpenStruct.new) do |kv_pair, struct|
            key, value = kv_pair

            struct[key] = structify(value)
          end
        elsif object.respond_to?(:map)
          object.map { |item| structify(item) }
        else
          object
        end
      end

      def find_concept_by_name(name)
        ConceptName.joins(:concept)
                   .merge(Concept.all) # Filter out voided
                   .where(name: CGI.unescapeHTML(name))
                   .first
      end
    end
  end
end
