# frozen_string_literal: true

require 'rails_helper'

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

  describe '#best_result' do
    it 'returns result' do
      place = Geo.best_result('Stockholm')
      expect(place.address).to eq('Stockholm, Sweden')
      expect(place.country_code).to eq('SE')
      expect(place.latitude).to eq(59.32932)
      expect(place.longitude).to eq(18.06858)
    end

    it 'returns nil result for no match' do
      place = Geo.best_result('watdress')
      expect(place.address).to eq('')
      expect(place.country_code).to eq('')
      expect(place.latitude).to be_nil
      expect(place.longitude).to be_nil
    end
  end
end
