# frozen_string_literal: true

require 'spec_helper'

require 'postal_code'

RSpec.describe PostalCode do
  describe '#to_s' do
    [
      ['  223 52  ', '223 52'],
      ['2 23 5 2  ', '223 52'],
      ['22352', '223 52'],
      [' 2235', '2235'],
      [nil, ''],
      ['watman ', 'watman'],
      ['', '']
    ].each do |data|
      input, expected = data

      it 'returns pretty zip code' do
        expect(described_class.new(input).to_s).to eq(expected)
      end
    end

    it 'returns emptry string if passed nil' do
      expect(described_class.new(nil).to_s).to eq('')
    end
  end
end
