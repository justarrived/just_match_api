# frozen_string_literal: true
module JsonApiHelpers
  module Params
    class Fields
      attr_reader :fields_params

      def initialize(fields_params)
        @fields_params = {}
        (fields_params || {}).each do |model_name, value|
          @fields_params[model_name] = value.split(',').map do |name|
            StringSupport.underscore(name.strip)
          end
        end
      end

      def to_h
        fields_params
      end
    end
  end
end
