# frozen_string_literal: true
module JsonApiHelpers
  module Params
    module Sort
      # NOTE: Rails only method: Object#present?
      def self.sorted_fields(sort, allowed, default)
        allowed = allowed.map(&:to_s)
        fields = sort.to_s.split(',')

        ordered_fields = convert_to_ordered_hash(fields)
        filtered_fields = ordered_fields.select { |key, _value| allowed.include?(key) }
        filtered_fields.empty? ? default : filtered_fields
      end

      def self.convert_to_ordered_hash(fields)
        fields.each_with_object({}) do |field, hash|
          if field.start_with?('-')
            # Underscore the field (JSONAPI attributes are by recommendation dasherized)
            field = field[1..-1].underscore
            hash[field] = :desc
          else
            # Underscore the field (JSONAPI attributes are by recommendation dasherized)
            hash[field.underscore] = :asc
          end
        end
      end
    end
  end
end
