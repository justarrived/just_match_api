# frozen_string_literal: true
require 'rails_helper'

RSpec.describe DateSupport do
  describe '#days_appart' do
    it 'returns the number of days appart' do
      days_appart = described_class.days_appart(4.days.ago, 2.days.ago)
      expect(days_appart).to eq(2)
    end
  end

  describe '#weekdays_in' do
    it 'only returns weekdays' do
      start = Date.new(2016, 4, 22)
      finish = Date.new(2016, 4, 26)

      expected = [
        Date.new(2016, 4, 22),
        Date.new(2016, 4, 25),
        Date.new(2016, 4, 26)
      ]
      result = described_class.weekdays_in(start, finish)
      expect(result).to eq(expected)
    end
  end
end
