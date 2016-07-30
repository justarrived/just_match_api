# frozen_string_literal: true
require 'spec_helper'

RSpec.describe JsonApiHelpers::Serializers::Error do
  let(:pointer) { nil }
  let(:attribute) { nil }

  subject do
    described_class.new(
      status: 422, detail: 'too short', pointer: pointer, attribute: attribute
    ).to_h
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

  context 'without pointer and attribute' do
    let(:pointer) { nil }
    let(:attribute) { nil }

    it 'returns a response without source-key' do
      expect(subject[:source]).to be_nil
    end
  end
end
