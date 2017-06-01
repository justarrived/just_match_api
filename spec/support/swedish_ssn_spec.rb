# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SwedishSSN do
  let(:personnummer) { '8908030334' }
  let(:personnummer_normalized) { '890803-0334' }
  let(:samordningsnummer) { '7010632391' }
  let(:samordningsnummer_normalized) { '701063-2391' }

  describe '#valid?' do
    it 'returns true for a valid ssn' do
      expect(described_class.valid?(personnummer)).to eq(true)
    end

    it 'returns true for a valid "samordningsnummer"' do
      expect(described_class.valid?(samordningsnummer)).to eq(true)
    end

    it 'returns false for a valid ssn' do
      expect(described_class.valid?('8908')).to eq(false)
    end
  end

  describe '#normalize' do
    it 'returns the normalized ssn if valid' do
      expect(described_class.normalize('198908030334')).to eq(personnummer_normalized)
      expect(described_class.normalize('19890803-0334')).to eq(personnummer_normalized)
      expect(described_class.normalize('8908030334')).to eq(personnummer_normalized)
    end

    it 'returns the normalized ssn if valid "samordningsnummer"' do
      expected = samordningsnummer_normalized
      expect(described_class.normalize(samordningsnummer)).to eq(expected)
    end

    it 'returns the ssn untouched if invalid' do
      expect(described_class.normalize('8908')).to eq('8908')
    end

    it 'returns nil if passed nil' do
      expect(described_class.normalize(nil)).to be_nil
    end
  end
end
