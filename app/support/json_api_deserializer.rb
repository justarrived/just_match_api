# frozen_string_literal: true
module JsonApiDeserializer
  AmsDeserializer = ActiveModelSerializers::Deserialization
  Parameters = ActionController::Parameters

  def self.parse(params)
    parsed_params = AmsDeserializer.jsonapi_parse(params)
    Parameters.new(parsed_params)
  end
end
