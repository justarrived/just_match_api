# frozen_string_literal: true
module JsonApiHelpers
  module Serializers
    module ModelError
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
          field, error.fetch(:error), count: error[:count]
        )
      end

      def self.error_meta_for(error)
        meta = { type: error.fetch(:error) }
        meta[:count] = error[:count] if error[:count]
        meta
      end
    end
  end
end
