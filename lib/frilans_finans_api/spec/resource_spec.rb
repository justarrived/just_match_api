# frozen_string_literal: true
require 'spec_helper'

RSpec.describe FrilansFinansApi::Resource do
  let(:data) do
    json = FrilansFinansApi::FixtureClient.new.read(:profession)
    JSON.parse(json)['data']
  end

  subject { described_class.new(data) }

  it 'can return #type' do
    expect(subject.type).to eq('profession')
  end

  it 'can return #id' do
    expect(subject.id).to eq('1')
  end

  it 'can return #attributes' do
    expect(subject.attributes['ssyk']).to eq(1)
  end

  it 'can return #self_link' do
    expected = 'https://frilansfinans.se/api/profession/1'
    expect(subject.self_link).to eq(expected)
  end
end
