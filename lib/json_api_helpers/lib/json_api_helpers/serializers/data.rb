# frozen_string_literal: true
require 'active_support/core_ext/hash/keys'

module JsonApiHelpers
  module Serializers
    class Data
      def initialize(id:, type:, attributes: {})
        @id = id
        @type = type
        @attributes = attributes
      end

      def to_h(shallow: false)
        data = {
          id: @id,
          type: KeyTransform.(@type.to_s),
          attributes: KeyTransform.(@attributes)
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
