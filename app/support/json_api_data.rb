# frozen_string_literal: true
class JsonApiData
  def initialize(id:, type:, attributes: {})
    @id = id
    @type = type
    @attributes = attributes
  end

  # Rails is awkward and calls #to_json with a context argument
  def to_json(_context = nil)
    {
      data: {
        id: @id,
        type: @type,
        attributes: @attributes.deep_transform_keys! { |key| key.to_s.dasherize }
      }
    }.to_json
  end
end
