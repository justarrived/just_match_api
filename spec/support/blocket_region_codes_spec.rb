# frozen_string_literal: true

RSpec.describe BlocketRegionCodes do
  describe '#to_municipality_code' do
    it 'returns the correct data for city that requires suffix' do
      expect(described_class.to_municipality_code('Stockholm')).to eq('131')
      expect(described_class.to_municipality_code('Stockholms stad')).to eq('131')
      expect(described_class.to_municipality_code('Jönköping stad')).to eq('218')
      expect(described_class.to_municipality_code('Jönköping')).to eq('218')
    end

    it 'returns the correct data for city' do
      expect(described_class.to_municipality_code('Kiruna')).to eq('8')
    end
  end

  describe '#to_region_code' do
    it 'returns the correct data' do
      expect(described_class.to_region_code('Stockholm')).to eq('11')
      expect(described_class.to_region_code('Kiruna')).to eq('1')
    end
  end

  describe '#to_region_name' do
    it 'returns the correct data' do
      expect(described_class.to_region_name('Stockholm')).to eq('Stockholm')
      expect(described_class.to_region_name('Stockholms stad')).to eq('Stockholm')
      expect(described_class.to_region_name('Kiruna')).to eq('Norrbotten')
    end
  end
end
