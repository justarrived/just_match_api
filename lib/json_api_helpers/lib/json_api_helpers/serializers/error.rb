# frozen_string_literal: true
module JsonApiHelpers
  module Serializers
    class Error
      def initialize(detail:, status: 422, code: nil, pointer: nil, attribute: nil)
        @status = status
        @detail = detail
        @pointer = pointer(pointer: pointer, attribute: attribute)
        @code = code
      end

      def to_h
        response = { status: @status, code: @code, detail: @detail }
        response.merge!(@pointer)
      end

      private

      def pointer(pointer:, attribute:)
        return {} if pointer.nil? && attribute.nil?

        full_pointer = if pointer
                         pointer
                       else
                         "/data/attributes/#{KeyTransform.call(attribute.to_s)}"
                       end
        {
          source: {
            pointer: full_pointer
          }
        }
      end
    end
  end
end
