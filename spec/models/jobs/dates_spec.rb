# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Jobs::Dates do
  describe '#starts_in_the_future?' do
    it 'defaults to return true if starts_at is nil' do
      expect(described_class.new.starts_in_the_future?).to eq(true)
    end

    it 'returns true if starts_at is in the future' do
      dates = described_class.new(starts_at: Date.new(3099, 1, 1))
      expect(dates.starts_in_the_future?).to eq(true)
    end

    it 'returns false if starts_at is in the past' do
      dates = described_class.new(starts_at: Date.new(1099, 1, 1))
      expect(dates.starts_in_the_future?).to eq(false)
    end

    it 'returns true if starts_at is nil and ends_at is in the future' do
      dates = described_class.new(ends_at: Date.new(3099, 1, 1))
      expect(dates.starts_in_the_future?).to eq(true)
    end

    it 'returns false if starts_at is nil and ends_at is in the past' do
      dates = described_class.new(ends_at: Date.new(1099, 1, 1))
      expect(dates.starts_in_the_future?).to eq(false)
    end
  end

  describe '#open_for_applications?' do
    it 'defaults to return true if all dates are nil' do
      expect(described_class.new.open_for_applications?).to eq(true)
    end

    it 'returns true if last_application_at is in the future' do
      dates = described_class.new(last_application_at: Date.new(3099, 1, 1))
      expect(dates.open_for_applications?).to eq(true)
    end

    it 'returns false if last_application_at is in the past' do
      dates = described_class.new(last_application_at: Date.new(1099, 1, 1))
      expect(dates.open_for_applications?).to eq(false)
    end

    context 'last_application_at is nil' do
      it 'returns true if starts_at is in the future' do
        dates = described_class.new(starts_at: Date.new(3099, 1, 1))
        expect(dates.open_for_applications?).to eq(true)
      end

      it 'returns false if starts_at is in the past' do
        dates = described_class.new(starts_at: Date.new(1099, 1, 1))
        expect(dates.open_for_applications?).to eq(false)
      end

      it 'returns true if starts_at is nil and ends_at is in the future' do
        dates = described_class.new(ends_at: Date.new(3099, 1, 1))
        expect(dates.open_for_applications?).to eq(true)
      end

      it 'returns false if starts_at is nil and ends_at is in the past' do
        dates = described_class.new(ends_at: Date.new(1099, 1, 1))
        expect(dates.open_for_applications?).to eq(false)
      end
    end
  end
end
