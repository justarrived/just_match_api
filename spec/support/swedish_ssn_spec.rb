# frozen_string_literal: true
require 'spec_helper'

RSpec.describe SwedishSSN do
  describe '#valid?' do
    it 'returns true for a valid ssn' do
      expect(described_class.valid?('890803-0334')).to eq(true)
    end

    it 'returns false for a valid ssn' do
      expect(described_class.valid?('8908')).to eq(false)
    end
  end

  describe '#normalize' do
    it 'returns the normalized ssn if valid' do
      ssn = '890803-0334'
      expect(described_class.normalize('198908030334')).to eq(ssn)
      expect(described_class.normalize('19890803-0334')).to eq(ssn)
      expect(described_class.normalize('8908030334')).to eq(ssn)
    end

    it 'returns the ssn untouched if invalid' do
      expect(described_class.normalize('8908')).to eq('8908')
    end

    it 'returns nil if passed nil' do
      expect(described_class.normalize(nil)).to be_nil
    end
  end
end
