# frozen_string_literal: true

require 'set'

module JsonApiHelpers
  module Serializers
    module ModelError
      KNOWN_ERROR_TYPES = Set.new(%i(
                                    accepted
                                    blank
                                    confirmation
                                    empty
                                    equal_to
                                    even
                                    exclusion
                                    greater_than
                                    greater_than_or_equal_to
                                    inclusion
                                    invalid
                                    less_than
                                    less_than_or_equal_to
                                    not_a_number
                                    not_an_integer
                                    odd
                                    other_than
                                    present
                                    required
                                    taken
                                    too_long
                                    too_short
                                    wrong_length
                                  )).freeze

      def self.serialize(model, key_transform: JsonApiHelpers.default_key_transform)
        model.errors.details.flat_map do |field, errors|
          errors.map do |error|
            attribute_name = KeyTransform.call(field.to_s, key_transform: key_transform)

            {
              status: 422,
              source: { pointer: "/data/attributes/#{attribute_name}" },
              detail: error_message_for(model.errors, field, error),
              meta: error_meta_for(error)
            }
          end
        end
      end

      def self.error_message_for(model_errors, field, error)
        model_errors.generate_message(
          field, error_type_for(error.fetch(:error)), count: error[:count]
        )
      end

      def self.error_meta_for(error)
        meta = {
          type: error_type_for(error.fetch(:error))
        }
        meta[:count] = error[:count] if error[:count]
        meta[:value] = error[:value] if error[:value]
        meta
      end

      def self.error_type_for(error_type)
        return error_type if KNOWN_ERROR_TYPES.include?(error_type)
        :invalid
      end
    end
  end
end
