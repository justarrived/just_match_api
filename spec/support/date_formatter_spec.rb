# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DateFormatter do
  describe '#distance_of_time_in_words_from_now' do
    it 'returns the time from now' do
      date = Time.zone.now + 5.days
      result = described_class.new.distance_of_time_in_words_from_now(date)
      expect(result).to eq('5 days')
    end

    it 'returns nil when passed nil' do
      expect(described_class.new.distance_of_time_in_words_from_now(nil)).to eq(nil)
    end
  end

  describe '#yyyy_mm_dd' do
    it 'returns the time formatted as YYYY-MM-DD' do
      date = Date.new(2018, 1, 1)
      result = described_class.new.yyyy_mm_dd(date)
      expect(result).to eq('2018-01-01')
    end

    it 'returns nil when passed nil' do
      expect(described_class.new.yyyy_mm_dd(nil)).to eq(nil)
    end
  end
end
