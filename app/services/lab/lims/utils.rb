# frozen_string_literal: true

require 'cgi/util'

require_relative 'exceptions'

module Lab
  module Lims
    ##
    # Various helper methods for modules in the Lims namespaces...
    module Utils
      LIMS_LOG_PATH = Rails.root.join('log', 'lims')
      FileUtils.mkdir_p(LIMS_LOG_PATH)

      def logger
        Rails.logger
      end

      TEST_NAME_MAPPINGS = {
        # For some weird reason(s) some tests have multiple names in LIMS,
        # this is used to sanitize those names.
        'hiv_viral_load' => 'HIV Viral Load',
        'viral laod' => 'HIV Viral Load',
        'viral load' => 'HIV Viral Load',
        'i/ink' => 'India ink',
        'indian ink' => 'India ink'
      }.freeze

      def self.translate_test_name(test_name)
        TEST_NAME_MAPPINGS.fetch(test_name.downcase, test_name)
      end

      def self.structify(object)
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

      def self.lab_user
        # Use unscoped to find user regardless of location context
        user = User.unscoped.find_by_username('lab_daemon')
        return user if user

        god_user = User.first
        User.current = god_user
        person = Person.create!(creator: god_user.user_id, birthdate: '1980-01-01')
        PersonName.create!(person: person, given_name: 'Lab', family_name: 'Daemon', creator: god_user.user_id)
        User.create!(username: 'lab_daemon', person:, creator: god_user.user_id)
      end

      # Earliest date accepted from LIMS. Anything older is a corrupted
      # legacy date (e.g. year 0026 or 18xx), not a real lab order.
      EARLIEST_VALID_DATE = Date.new(2000, 1, 1)

      ##
      # Parses a LIMS date, accepting only real calendar dates with a
      # four-digit year between EARLIEST_VALID_DATE and tomorrow (to allow for
      # timezone differences). Invalid dates are never guessed at or rewritten:
      # the fallback date is used if one is given, otherwise InvalidDate is
      # raised.
      def self.parse_date(str_date, fallback_date = nil)
        str_date = str_date&.to_s

        raise "Can't parse blank date" if str_date.blank? && fallback_date.blank?

        return parse_date(fallback_date) if str_date.blank?

        date = begin
          case str_date
          when /\d{4}-\d{2}-\d{2}/
            str_date
          when /\d{2}-\d{2}-\d{4}/
            Date.strptime(str_date, '%d-%m-%Y').strftime('%Y-%m-%d')
          when /(\d{4}\d{2}\d{2})\d+/
            Date.strptime(str_date, '%Y%m%d').strftime('%Y-%m-%d')
          when %r{\d{2}/\d{2}/\d{4}}
            str_date.to_date.to_s
          end
        rescue Date::Error, ArgumentError
          nil
        end

        return date if valid_date?(date)

        Rails.logger.warn("Invalid date: #{str_date}")
        raise InvalidDate, "Invalid date: #{str_date}" if fallback_date.blank?

        parse_date(fallback_date)
      end

      def self.valid_date?(date)
        return false if date.blank?

        date.to_date.between?(EARLIEST_VALID_DATE, Date.current + 1.day)
      rescue Date::Error, ArgumentError
        false
      end

      def self.find_concept_by_name(name)
        unescaped_name = CGI.unescapeHTML(name)
        attribute_type_id = ConceptAttributeType.test_catalogue_name.concept_attribute_type_id

        attribute = ConceptAttribute.where('attribute_type_id = ? AND value_reference = ?', attribute_type_id, unescaped_name).first
        return attribute.concept if attribute

        ConceptName.joins('INNER JOIN concept_attribute ON concept_attribute.concept_id = concept_name.concept_id')
                   .where('concept_attribute.attribute_type_id = ? AND concept_attribute.value_reference = ? AND concept_name.name = ?',
                          attribute_type_id, unescaped_name, unescaped_name)
                   .first
      end
    end
  end
end
