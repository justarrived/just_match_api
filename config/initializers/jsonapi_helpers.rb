# frozen_string_literal: true

# Require shorthands/aliases for JSONAPIHelpers
JsonApiErrors = JSONAPIHelpers::Serializers::Errors
JsonApiData = JSONAPIHelpers::Serializers::Data
JsonApiDatum = JSONAPIHelpers::Serializers::Datum
JsonApiRelationships = JSONAPIHelpers::Serializers::Relationships

JsonApiErrorSerializer = JSONAPIHelpers::Serializers::ModelError
JsonApiSerializer = JSONAPIHelpers::Serializers::Model

JsonApiDeserializer = JSONAPIHelpers::Serializers::Deserializer

JsonApiFilterParams = JSONAPIHelpers::Params::Filter
JsonApiSortParams = JSONAPIHelpers::Params::Sort
JsonApiFieldsParams = JSONAPIHelpers::Params::Fields
JsonApiIncludeParams = JSONAPIHelpers::Params::Includes

JSONAPIHelpers.configure do |config|
  config.key_transform = :unaltered
  config.deserializer_klass = ActiveModelSerializers::Deserialization
  config.params_klass = ActionController::Parameters
end
