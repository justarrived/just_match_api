require 'spec_helper'

RSpec.describe Geo do
  describe '#best_coordinates' do
    it 'returns coordinates' do
      coordinates = Geo.best_coordinates('Stockholm')
      expect(coordinates.latitude).to eq(59.32932)
      expect(coordinates.longitude).to eq(18.06858)
    end

    it 'returns nil coordinates for no match' do
      coordinates = Geo.best_coordinates('watdress')
      expect(coordinates.latitude).to eq(nil)
      expect(coordinates.longitude).to eq(nil)
    end
  end
end
