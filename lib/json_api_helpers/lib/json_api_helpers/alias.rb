# frozen_string_literal: true
module JsonApiHelpers
  module Alias
    JsonApiError = JsonApiHelpers::Helper::Error
    JsonApiErrors = JsonApiHelpers::Helper::Errors
    JsonApiData = JsonApiHelpers::Helper::Data
    JsonApiDatum = JsonApiHelpers::Helper::Datum

    JsonApiSerializer = JsonApiHelpers::AMS::Serializer
    JsonApiDeserializer = JsonApiHelpers::AMS::Deserializer
  end
end
