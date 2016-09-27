# frozen_string_literal: true
require 'rails_helper'

RSpec.describe DateSupport do
  let(:start) { Date.new(2016, 4, 22) }
  let(:finish) { Date.new(2016, 4, 26) }

  describe '#days_in' do
    it 'returns the number of days appart' do
      days_in = described_class.days_in(start, finish)

      expected = [
        Date.new(2016, 4, 22),
        Date.new(2016, 4, 23),
        Date.new(2016, 4, 24),
        Date.new(2016, 4, 25),
        Date.new(2016, 4, 26)
      ]

      expect(days_in).to eq(expected)
    end

    context 'if start and end date is the same date' do
      let(:start) { Date.new(2016, 4, 22) }
      let(:finish) { start }

      it 'returns the date' do
        days_in = described_class.days_in(start, finish)

        expected = [start]
        expect(days_in).to eq(expected)
      end
    end
  end

  describe '#weekdays_in' do
    it 'only returns weekdays' do
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
