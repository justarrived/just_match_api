# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FilterParams do
  let(:filter_hash) do
    {
      'name' => 'watman',
      'created-at' => '2016-03-03..2016-03-04',
      'published' => 'true'
    }
  end

  describe '#filtered_fields' do
    it 'returns empty hash when no filers are present' do
      expect(described_class.filtered_fields({}, [], {})).to eq({})
    end

    it 'returns empty hash when filter is a string' do
      expect(described_class.filtered_fields('', [], {})).to eq({})
    end

    it 'returns empty hash when filter is nil' do
      expect(described_class.filtered_fields(nil, [], {})).to eq({})
    end

    it 'returns empty hash when there is no allowed keys' do
      result = described_class.filtered_fields(filter_hash, [], {})
      expect(result).to eq({})
    end

    it 'only returns allowed keys' do
      result = described_class.filtered_fields(filter_hash, [:name], {})
      expect(result).to eq(name: 'watman')
    end

    it 'can transform values' do
      transform = { created_at: :date_range }
      result = described_class.filtered_fields(filter_hash, [:created_at], transform)
      expect(result[:created_at].first).to be_a(Date)
    end
  end

  describe '#format_value' do
    it 'returns value untouched if there is now assocaiated type transformer' do
      value = 'watman'
      result = described_class.format_value(value, nil)
      expect(result).to eq(value)
    end

    it 'date_range type delegates to #format_date_range' do
      allow(described_class).to receive(:format_date_range)
      described_class.format_value('', :date_range)
      expect(described_class).to have_received(:format_date_range)
    end
  end

  describe '#format_date_range' do
    it 'returns nil of either start or end range is not a valid date' do
      value = 'watman..2016-03-03'
      result = described_class.format_date_range(value)
      expect(result).to be_nil
    end

    it 'returns date range when it recieves valid dates' do
      first = '2016-03-01'
      last = '2016-03-03'
      value = "#{first}..#{last}"
      result = described_class.format_date_range(value)
      expect(result.first).to eq(Date.parse(first))
      expect(result.last).to eq(Date.parse(last))
    end
  end
end
