
# frozen_string_literal: true

require 'spec_helper'
require 'active_model'

RSpec.describe JsonApiHelpers::Serializers::ModelError do
  class ExampleModel
    include ActiveModel::Model

    attr_accessor :name
    validates :name, length: { minimum: 3 }, presence: true

    def add_custom_error
      errors.add(:name, 'is not OK')
    end
  end

  let(:model) { ExampleModel.new.tap(&:validate) }
  let(:errors) { described_class.serialize(model) }
  let(:min_error) { errors.first }
  let(:blank_error) { errors.last }

  it 'returns an array' do
    expect(errors).to be_an(Array)
  end

  it 'returns 422 unprocessable entity status' do
    expect(min_error[:status]).to eq(422)
  end

  it 'returns source key' do
    expect(min_error[:source]).to be_a(Hash)
  end

  it 'returns the correct pointer under source key' do
    expect(min_error.dig(:source, :pointer)).to eq('/data/attributes/name')
  end

  it 'returns the correct error detail' do
    expect(min_error[:detail]).to eq('is too short (minimum is 3 characters)')
  end

  it 'returns the correct error detail for a custom error' do
    model = ExampleModel.new
    model.add_custom_error
    errors = described_class.serialize(model)
    expect(errors.first[:detail]).to eq('is not OK')
  end

  it 'returns correct meta hash for too short error' do
    expect(min_error[:meta]).to eq(type: :too_short, count: 3)
  end

  it 'returns correct meta hash for presence error' do
    expect(blank_error[:meta]).to eq(type: :blank)
  end

  it 'returns invalid as error type for unknown types' do
    model = ExampleModel.new
    model.errors.add(:name, 'watman error')
    error = described_class.serialize(model).first
    expect(error[:meta]).to eq(type: :invalid)
  end
end
