# frozen_string_literal: true

require 'active_support/core_ext/string'
require 'active_support/core_ext/hash/keys'

# Slightly modified from https://github.com/rails-api/active_model_serializers/blob/a1826186e556b4aa6cbe2a2588df8b2186e06252/lib/active_model_serializers/key_transform.rb
module JsonApiHelpers
  module KeyTransform
    module_function

    def call(object, key_transform: nil)
      key_transform ||= JsonApiHelpers.config.key_transform
      public_send(key_transform, object)
    end

    # Transforms values to UpperCamelCase or PascalCase.
    #
    # @example:
    #    "some_key" => "SomeKey",
    def camel(value)
      case value
      when Hash then value.deep_transform_keys! { |key| camel(key) }
      when Symbol then camel(value.to_s).to_sym
      when String then StringSupport.camel(value)
      else value
      end
    end

    # Transforms values to camelCase.
    #
    # @example:
    #    "some_key" => "someKey",
    def camel_lower(value)
      case value
      when Hash then value.deep_transform_keys! { |key| camel_lower(key) }
      when Symbol then camel_lower(value.to_s).to_sym
      when String then StringSupport.camel_lower(value)
      else value
      end
    end

    # Transforms values to dashed-case.
    # This is the default case for the JsonApi adapter.
    #
    # @example:
    #    "some_key" => "some-key",
    def dash(value)
      case value
      when Hash then value.deep_transform_keys! { |key| dash(key) }
      when Symbol then dash(value.to_s).to_sym
      when String then StringSupport.dash(value)
      else value
      end
    end

    # Transforms values to underscore_case.
    # This is the default case for deserialization in the JsonApi adapter.
    #
    # @example:
    #    "some-key" => "some_key",
    def underscore(value)
      case value
      when Hash then value.deep_transform_keys! { |key| underscore(key) }
      when Symbol then underscore(value.to_s).to_sym
      when String then StringSupport.underscore(value)
      else value
      end
    end

    # Returns the value unaltered
    def unaltered(value)
      value
    end
  end
end
