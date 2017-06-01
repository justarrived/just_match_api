# frozen_string_literal: true

# Require shorthands/aliases for JsonApiHelpers
JsonApiErrors = JsonApiHelpers::Serializers::Errors
JsonApiData = JsonApiHelpers::Serializers::Data
JsonApiDatum = JsonApiHelpers::Serializers::Datum
JsonApiRelationships = JsonApiHelpers::Serializers::Relationships

JsonApiErrorSerializer = JsonApiHelpers::Serializers::ModelError
JsonApiSerializer = JsonApiHelpers::Serializers::Model

JsonApiDeserializer = JsonApiHelpers::Serializers::Deserializer

JsonApiFilterParams = JsonApiHelpers::Params::Filter
JsonApiSortParams = JsonApiHelpers::Params::Sort
JsonApiFieldsParams = JsonApiHelpers::Params::Fields
JsonApiIncludeParams = JsonApiHelpers::Params::Includes

JsonApiHelpers.configure do |config|
  config.key_transform = :unaltered
  config.deserializer_klass = ActiveModelSerializers::Deserialization
  config.params_klass = ActionController::Parameters
end
