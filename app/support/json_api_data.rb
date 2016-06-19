# frozen_string_literal: true
class JsonApiData
  def initialize(id:, type:, attributes: {})
    @id = id
    @type = type
    @attributes = attributes
  end

  def to_h(shallow: false)
    data = {
      id: @id,
      type: @type.to_s.dasherize,
      attributes: @attributes.deep_transform_keys! { |key| key.to_s.dasherize }
    }

    if shallow
      data
    else
      { data: data }
    end
  end

  # Rails is awkward and calls #to_json with a context argument
  def to_json(_context = nil)
    to_h.to_json
  end
end
