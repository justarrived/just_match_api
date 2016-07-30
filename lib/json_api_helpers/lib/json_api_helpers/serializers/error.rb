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

      # delegate :to_json, to: :to_h
      def to_json
        to_h
      end

      private

      def pointer=(pointer)
        @pointer = {}
        return @pointer if pointer.nil?

        @pointer = {
          source: {
            pointer: "/data/attributes/#{pointer.to_s.dasherize}"
          }
        }
      end
    end
  end
end
