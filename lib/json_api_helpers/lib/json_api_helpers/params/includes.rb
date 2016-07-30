# frozen_string_literal: true
module JsonApiHelpers
  module Params
    class Includes
      attr_reader :include_param

      def initialize(include_param)
        @include_param = StringSupport.underscore(include_param || '')
      end

      def permit(*permitted_includes)
        include_array = include_param.split(',')
        include_array & permitted_includes.flatten(1)
      end
    end
  end
end
