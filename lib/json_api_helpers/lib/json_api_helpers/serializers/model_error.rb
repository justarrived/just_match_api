# frozen_string_literal: true
module JsonApiHelpers
  module Serializers
    module ModelError
      def self.serialize(model)
        model.errors.messages.flat_map do |field, errors|
          errors.map do |error_message|
            {
              status: 422,
              source: { pointer: "/data/attributes/#{KeyTransform.call(field.to_s)}" },
              detail: error_message
            }
          end
        end
      end
    end
  end
end
