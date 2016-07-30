# frozen_string_literal: true
require 'active_support/core_ext/string'
require 'active_support/core_ext/hash'
require 'active_support/core_ext/object/json'

# Local requires
require 'json_api_helpers/version'

require 'json_api_helpers/serializers/deserializer'
require 'json_api_helpers/serializers/model'
require 'json_api_helpers/serializers/model_error'
require 'json_api_helpers/serializers/data'
require 'json_api_helpers/serializers/datum'
require 'json_api_helpers/serializers/error'
require 'json_api_helpers/serializers/errors'

require 'json_api_helpers/params/fields'
require 'json_api_helpers/params/filter'
require 'json_api_helpers/params/sort'

# Defines aliases for most classes
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
