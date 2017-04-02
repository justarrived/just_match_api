# frozen_string_literal: true

require 'active_support/core_ext/hash/keys'

module JsonApiHelpers
  module Serializers
    class Relationships
      def initialize
        @relationships = {}
      end

      def add(relation:, id:, type:)
        @relationships[relation] = { id: id, type: type }
      end

      def to_h
        @relationships
      end

      # Rails is awkward and calls #to_json with a context argument
      # NOTE: Rails only method Hash#to_json
      def to_json(_context = nil)
        to_h.to_json
      end
    end
  end
end
