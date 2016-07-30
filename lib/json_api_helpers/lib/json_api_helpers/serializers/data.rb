# frozen_string_literal: true
module JsonApiHelpers
  module Serializers
    class Data
      def initialize(id:, type:, attributes: {})
        @id = id
        @type = type
        @attributes = attributes
      end

      # NOTE: Rails only methods used:
      #   String#dasherize
      #   Hash#deep_transform_keys!
      def to_h(shallow: false)
        data = {
          id: @id,
          type: @type.to_s.dasherize,
          attributes: @attributes.deep_transform_keys! { |key| key.to_s.dasherize }
        }

        if shallow
          data
        else
          { data: data }
        end
      end

      # Rails is awkward and calls #to_json with a context argument
      # NOTE: Rails only method Hash#to_json
      def to_json(_context = nil)
        to_h.to_json
      end
    end
  end
end
