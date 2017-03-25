# frozen_string_literal: true
RSpec::Matchers.define :be_jsonapi_response_for do |model|
  match do |actual|
    parsed_actual = JSON.parse(actual)

    correct_type_value = parsed_actual.dig('data', 'type') == model
    correct_attrs_type = parsed_actual.dig('data', 'attributes').is_a?(Hash)

    relation = parsed_actual.dig('data', 'relationships')
    # According to the JSONAPI spec its OK that relation is not present in the response
    correct_relation_type = relation.nil? ? true : relation.is_a?(Hash)

    correct_type_value && correct_attrs_type && correct_relation_type
  end
end

RSpec::Matchers.define :have_jsonapi_attribute_error_for do |expected_attribute|
  match do |actual|
    parsed_actual = JSON.parse(actual)
    errors = parsed_actual['errors']
    return false if errors.empty?
    errors.any? do |error|
      attribute = error.dig('source', 'pointer').split('data/attributes/').last
      attribute == expected_attribute.to_s
    end
  end
end

RSpec::Matchers.define :be_jsonapi_attribute do |attribute_name, attribute_value|
  match do |actual|
    parsed_actual = JSON.parse(actual)

    parsed_actual.dig('data', 'attributes', attribute_name) == attribute_value
  end
end
