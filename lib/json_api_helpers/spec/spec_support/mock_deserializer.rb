# frozen_string_literal: true
class MockDeserializer
  def self.jsonapi_parse(json_api_hash)
    json_api_hash.dig('data', 'attributes')
  end
end
