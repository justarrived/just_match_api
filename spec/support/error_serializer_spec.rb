# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ErrorSerializer do
  let(:model) { Skill.new.tap(&:validate) }
  subject { described_class.serialize(model) }

  it 'returns an array' do
    expect(subject).to be_an(Array)
  end

  it 'returns 422 unprocessable entity status' do
    expect(subject.first[:status]).to eq(422)
  end

  it 'returns source key' do
    expect(subject.first[:source]).to be_a(Hash)
  end

  it 'returns the correct pointer under source key' do
    expect(subject.first[:source][:pointer]).to eq('/data/attributes/name')
  end

  it 'returns an array' do
    expect(subject.first[:detail]).to eq('is too short (minimum is 3 characters)')
  end
end
