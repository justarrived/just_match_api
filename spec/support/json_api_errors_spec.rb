# frozen_string_literal: true
require 'rails_helper'

RSpec.describe JsonApiErrors do
  context 'with no errors' do
    subject { JSON.parse(JsonApiErrors.new.to_json) }

    it 'returns empty array' do
      expect(subject).to eq('errors' => [])
    end
  end

  context 'with errors' do
    subject do
      errors = JsonApiErrors.new
      errors.add(status: 422, detail: 'too short')
      json = errors.to_json
      JSON.parse(json)
    end

    it 'returns empty array' do
      expected = {
        'errors' => [{ 'status' => 422, 'detail' => 'too short' }]
      }
      expect(subject).to eq(expected)
    end
  end
end
