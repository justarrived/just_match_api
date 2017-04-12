# frozen_string_literal: true
require 'active_support/core_ext/hash/keys'
require 'json_api_helpers/serializers/relationships'

module JsonApiHelpers
  module Serializers
    class Data
      def initialize(id:, type:, attributes: {}, meta: {}, relationships: nil, key_transform: JsonApiHelpers.default_key_transform) # rubocop:disable Metrics/LineLength
        @id = id
        @type = type
        @attributes = attributes
        @meta = meta
        @relationships = relationships
        @key_transform = key_transform
      end

      def to_h(shallow: false)
        data = {
          id: @id,
          type: KeyTransform.call(@type.to_s, key_transform: @key_transform),
          attributes: KeyTransform.call(@attributes, key_transform: @key_transform)
        }

        if @relationships
          data[:relationships] = KeyTransform.call(
            @relationships.to_h,
            key_transform: @key_transform
          )
        end

        if shallow
          data
        else
          { data: data, meta: @meta }
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
