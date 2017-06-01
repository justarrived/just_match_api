# frozen_string_literal: true

module JsonApiHelpers
  module StringSupport
    module_function

    def camel(string)
      string.underscore.camelize
    end

    def camel_lower(string)
      string.underscore.camelize(:lower)
    end

    def dash(string)
      string.underscore.dasherize
    end

    def underscore(string)
      string.underscore
    end
  end
end
