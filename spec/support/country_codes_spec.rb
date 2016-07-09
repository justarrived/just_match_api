# frozen_string_literal: true
require 'spec_helper'

RSpec.describe CountryCodes do
  describe '#exists?' do
    it 'returns true if country code exists' do
      expect(described_class.exists?('SE')).to eq(true)
    end

    it 'returns false if country code does *not* exists' do
      expect(described_class.exists?('ZZ')).to eq(false)
    end
  end

  describe '#all' do
    it 'returns all country codes' do
      expect(described_class.all.length).to eq(249)
    end
  end
end
