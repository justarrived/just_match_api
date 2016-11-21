# frozen_string_literal: true
require 'rails_helper'

RSpec.describe I18nFallback do
  subject { described_class }

  describe '#get' do
    it 'returns fallback for symbol locale' do
      expect(subject.get(:en)).to eq(['sv'])
    end

    it 'returns fallback for string locale' do
      expect(subject.get('en')).to eq(['sv'])
    end

    it 'returns empty fallback for unknown locale' do
      expect(subject.get('watman')).to eq([])
    end
  end

  describe '#to_h' do
    it 'can return a has representation' do
      expect(subject.to_h).to be_a(Hash)
    end
  end
end
