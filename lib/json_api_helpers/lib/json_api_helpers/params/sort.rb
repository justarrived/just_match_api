# frozen_string_literal: true
module JsonApiHelpers
  module Params
    module Sort
      def self.build(sort, allowed, default)
        allowed = allowed.map(&:to_s)
        fields = sort.to_s.split(',')

        ordered_fields = convert_to_ordered_hash(fields)
        filtered_fields = ordered_fields.select { |key, _value| allowed.include?(key) }
        filtered_fields.empty? ? default : filtered_fields
      end

      def self.convert_to_ordered_hash(fields)
        fields.each_with_object({}) do |field, hash|
          if field.start_with?('-')
            field = StringSupport.underscore(field[1..-1])
            hash[field] = :desc
          else
            hash[StringSupport.underscore(field)] = :asc
          end
        end
      end
    end
  end
end
