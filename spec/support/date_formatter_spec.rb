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
end
