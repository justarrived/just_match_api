# frozen_string_literal: true
module JsonApiHelpers
  module Serializers
    class Error
      attr_reader :status, :detail, :code

      def initialize(detail:, status: 422, code: nil, pointer: nil, attribute: nil, key_transform: JsonApiHelpers.default_key_transform) # rubocop:disable Metrics/LineLength
        @status = status
        @detail = detail
        @pointer = pointer(pointer: pointer, attribute: attribute, key_transform: key_transform) # rubocop:disable Metrics/LineLength
        @code = code
      end

      def to_h
        response = { status: @status, detail: @detail }
        response[:code] = @code unless @code.nil?
        response.merge!(@pointer)
      end

      private

      def pointer(pointer:, attribute:, key_transform:)
        return {} if pointer.nil? && attribute.nil?

        full_pointer = if pointer
                         pointer
                       else
                         attribute_pointer(attribute, key_transform: key_transform)
                       end
        {
          source: {
            pointer: full_pointer
          }
        }
      end

      def attribute_pointer(attribute, key_transform:)
        attribute_name = KeyTransform.call(attribute.to_s, key_transform: key_transform)
        "/data/attributes/#{attribute_name}"
      end
    end
  end
end
