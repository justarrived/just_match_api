# frozen_string_literal: true
require 'date'

module JsonApiHelpers
  module Params
    module Filter
      def self.build(filters, allowed, transform = {})
        return {} if filters.nil? || filters.is_a?(String)

        filtered = {}
        filters.each do |key, value|
          key_sym = StringSupport.underscore(key).to_sym
          if allowed.include?(key_sym)
            filtered[key_sym] = format_value(value, transform[key_sym])
          end
        end
        filtered
      end

      def self.format_value(value, type)
        case type
        when :date_range
          format_date_range(value)
        else
          value
        end
      end

      def self.format_date_range(value)
        date_parts = value.split('..')
        start = _parse_date_string(date_parts.first)
        finish = _parse_date_string(date_parts.last)
        start..finish
      rescue ArgumentError, 'invalid date' => _e
        nil
      end

      def self._parse_date_string(string)
        Date.parse(string, false)
      end
    end
  end
end
