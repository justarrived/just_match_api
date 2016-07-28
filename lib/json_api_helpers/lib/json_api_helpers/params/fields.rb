# frozen_string_literal: true
module JsonApiHelpers
  module Params
    class Fields
      attr_reader :fields_params

      def initialize(fields_params)
        @fields_params = fields_params || {}
      end

      def permit(resources_hash)
        permitted = {}
        resources_hash.map do |resource_symbol, whitelisted_fields|
          requested_fields = fields_params[resource_symbol]
          whitelist = whitelisted_fields.map(&:to_s)

          permitted[resource_symbol] = merge_fields(requested_fields, whitelist)
        end
        permitted
      end

      private

      def merge_fields(requested_fields, whitelisted_fields)
        if requested_fields
          requested_fields.split(',') & whitelisted_fields
        else
          whitelisted_fields
        end
      end
    end
  end
end
