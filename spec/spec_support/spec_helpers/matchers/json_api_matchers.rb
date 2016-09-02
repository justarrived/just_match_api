# frozen_string_literal: true
def hash_or_nil?(value)
  value.nil? || value.is_a?(Hash)
end

def has_jsonapi_root_keys(actual, model)
  actual.dig('data', 'type') == model &&
    actual.dig('data', 'id').is_a?(String) &&
    hash_or_nil?(actual.dig('data', 'attributes')) &&
    hash_or_nil?(actual.dig('data', 'relationships'))
end

# For testing contollers responses
RSpec::Matchers.define :be_jsonapi_response_for do |dashed_model_name|
  match do |actual|
    has_jsonapi_root_keys(JSON.parse(actual), dashed_model_name)
  end
end

# For testing serializers
RSpec::Matchers.define :be_jsonapi_formatted do |dashed_model_name|
  match do |actual|
    has_jsonapi_root_keys(actual, dashed_model_name)
  end
end

# For testing serializer attributes
RSpec::Matchers.define :have_jsonapi_attribute do |field, value|
  match do |actual|
    # Format a datetime value correctly
    value = value.as_json if value.is_a?(ActiveSupport::TimeWithZone)
    # Symbols are strings in JSON..
    value = value.to_s if value.is_a?(Symbol)

    actual.dig('data', 'attributes', field) == value
  end
end

# For testing serializer relationships
RSpec::Matchers.define :have_jsonapi_relationship do |model, _value|
  match do |actual|
    actual.dig('data', 'relationships', model).is_a?(Hash)
  end
end
