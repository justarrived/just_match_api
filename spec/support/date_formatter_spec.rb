# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DateFormatter do
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
