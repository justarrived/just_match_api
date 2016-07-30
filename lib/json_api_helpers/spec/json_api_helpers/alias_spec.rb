# frozen_string_literal: true
require 'spec_helper'

RSpec.describe JsonApiHelpers::Alias do
  it 'defines JsonApiError' do
    expect(defined?(described_class::JsonApiError)).to eq('constant')
  end

  it 'defines JsonApiErrors' do
    expect(defined?(described_class::JsonApiErrors)).to eq('constant')
  end

  it 'defines JsonApiData' do
    expect(defined?(described_class::JsonApiData)).to eq('constant')
  end

  it 'defines JsonApiDatum' do
    expect(defined?(described_class::JsonApiDatum)).to eq('constant')
  end

  it 'defines JsonApiErrorSerializer' do
    expect(defined?(described_class::JsonApiErrorSerializer)).to eq('constant')
  end

  it 'defines JsonApiSerializer' do
    expect(defined?(described_class::JsonApiSerializer)).to eq('constant')
  end

  it 'defines JsonApiDeserializer' do
    expect(defined?(described_class::JsonApiDeserializer)).to eq('constant')
  end

  it 'defines JsonApiFilterParams' do
    expect(defined?(described_class::JsonApiFilterParams)).to eq('constant')
  end

  it 'defines JsonApiSortParams' do
    expect(defined?(described_class::JsonApiSortParams)).to eq('constant')
  end

  it 'defines JsonApiFieldsParams' do
    expect(defined?(described_class::JsonApiFieldsParams)).to eq('constant')
  end
end
