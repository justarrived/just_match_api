# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StringFormatter do
  describe '#to_html' do
    [
      ['', nil],
      ['   ', nil],
      [nil, nil],
      ['Just Arrived', "<p>Just Arrived</p>\n"],
      ["Just \n Arrived", "<p>Just <br />\n Arrived</p>\n"]
    ].each do |values|
      argument, expected = values

      it "returns correct value for #{argument}" do
        expect(described_class.new.to_html(argument)).to eq(expected)
      end
    end
  end

  describe '#force_utf8' do
    it 'replaces all non-UTF-8 characters' do
      expect(described_class.new.force_utf8("Watman \xBF")).to eq('Watman �')
    end

    it 'returns string untouched if chars are UTF-8' do
      expect(described_class.new.force_utf8('WATMAN')).to eq('WATMAN')
    end

    it 'returns nil when passed nil' do
      expect(described_class.new.force_utf8(nil)).to eq(nil)
    end
  end
end
