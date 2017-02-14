# frozen_string_literal: true
require 'spec_helper'

RSpec.describe JsonApiHelpers::Serializers::Error do
  let(:pointer) { nil }
  let(:attribute) { nil }
  let(:key_transform) { :dash }

  subject do
    described_class.new(
      status: 422, detail: 'too short', pointer: pointer, attribute: attribute,
      key_transform: key_transform
    ).to_h
  end

  it '#detail' do
    detail = 'too short'
    expect(described_class.new(status: 422, detail: detail).detail).to eq(detail)
  end

  it '#code' do
    expect(described_class.new(status: 422, code: :wat, detail: '').code).to eq(:wat)
  end

  it '#status' do
    expect(described_class.new(status: 422, detail: '').status).to eq(422)
  end

  it 'returns correct status' do
    expect(subject[:status]).to eq(422)
  end

  it 'returns correct detail' do
    expect(subject[:detail]).to eq('too short')
  end

  context 'with pointer' do
    let(:pointer) { '/data/first_name' }

    it 'returns the correct pointer' do
      expected_pointer = { pointer: '/data/first_name' }
      expect(subject[:source]).to eq(expected_pointer)
    end
  end

  context 'with only attribute' do
    let(:pointer) { nil }
    let(:attribute) { :first_name }

    it 'returns correct pointer' do
      expected_pointer = { pointer: '/data/attributes/first-name' }
      expect(subject[:source]).to eq(expected_pointer)
    end
  end

  context 'with key transform underscore' do
    let(:pointer) { nil }
    let(:attribute) { 'first-name' }
    let(:key_transform) { :underscore }

    it 'returns correct pointer' do
      expected_pointer = { pointer: '/data/attributes/first_name' }
      expect(subject[:source]).to eq(expected_pointer)
    end
  end

  context 'without pointer and attribute' do
    let(:pointer) { nil }
    let(:attribute) { nil }

    it 'returns a response without source-key' do
      expect(subject[:source]).to be_nil
    end
  end
end
