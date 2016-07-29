# frozen_string_literal: true
module JsonApiHelpers
  module Alias
    JsonApiError = Helpers::Error
    JsonApiErrors = Helpers::Errors
    JsonApiData = Helpers::Data
    JsonApiDatum = Helpers::Datum

    JsonApiErrorSerializer = ErrorSerializer
    JsonApiSerializer = AMS::Serializer
    JsonApiDeserializer = AMS::Deserializer

    FilterParams = Params::Filter
    SortParams = Params::Sort
    FieldsParams = Params::Fields
  end
end
