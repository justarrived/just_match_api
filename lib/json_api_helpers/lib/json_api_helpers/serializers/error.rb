# frozen_string_literal: true
module JsonApiHelpers
  module Serializers
    class Error
      def initialize(detail:, status: 422, pointer: nil)
        @status = status
        @detail = detail
        self.pointer = pointer
      end

      def to_h
        response = { status: @status, detail: @detail }
        response.merge!(@pointer)
      end

      private

      def pointer=(pointer)
        @pointer = {}
        return @pointer if pointer.nil?

        @pointer = {
          source: {
            pointer: "/data/attributes/#{KeyTransform.(pointer.to_s)}"
          }
        }
      end
    end
  end
end
