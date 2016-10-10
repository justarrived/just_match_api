# frozen_string_literal: true
module JsonApiHelpers
  module Serializers
    module ModelError
      def self.serialize(model, key_transform: JsonApiHelpers.default_key_transform)
        model.errors.messages.flat_map do |field, errors|
          attribute_name = KeyTransform.call(field.to_s, key_transform: key_transform)
          errors.map do |error_message|
            {
              status: 422,
              source: { pointer: "/data/attributes/#{attribute_name}" },
              detail: error_message
            }
          end
        end
      end
    end
  end
end
