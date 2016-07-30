# frozen_string_literal: true
module JsonApiHelpers
  module Alias
    JsonApiError = Serializers::Error
    JsonApiErrors = Serializers::Errors
    JsonApiData = Serializers::Data
    JsonApiDatum = Serializers::Datum

    JsonApiErrorSerializer = ActiveModel::ErrorSerializer
    JsonApiSerializer = ActiveModel::Serializer
    JsonApiDeserializer = ActiveModel::Deserializer

    JsonApiFilterParams = Params::Filter
    JsonApiSortParams = Params::Sort
    JsonApiFieldsParams = Params::Fields
  end
end
