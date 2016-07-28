# frozen_string_literal: true
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'json_api_helpers'

require 'spec_support/mock_deserializer'
require 'spec_support/mock_params'

JsonApiHelpers.deserializer_klass = MockDeserializer
JsonApiHelpers.params_klass = MockParams
