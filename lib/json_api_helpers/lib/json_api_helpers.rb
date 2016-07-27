# frozen_string_literal: true
require 'active_support'
require 'active_support/core_ext/string'
require 'active_support/core_ext/hash'
require 'active_support/core_ext/object/json'

require 'active_model_serializers'

# Local requires
require 'ams/deserializer'
require 'ams/serializer'

require 'json_api_helpers/version'
require 'json_api_helpers/data'
require 'json_api_helpers/datum'
require 'json_api_helpers/error'
require 'json_api_helpers/errors'
require 'json_api_helpers/alias'

module JsonApiHelpers
  def self.deserializer_klass=(deserializer_klass)
    @deserializer_klass = deserializer_klass
  end

  def self.deserializer_klass
    @deserializer_klass || ActiveModelSerializers::Deserialization
  end

  def self.params_klass=(params_klass)
    @params_klass = params_klass
  end

  def self.params_klass
    @params_klass || ActionController::Parameters
  end
end
