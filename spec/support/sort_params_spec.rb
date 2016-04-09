# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SortParams do
  let(:default) { %w(created_at) }

  describe '#sorted_fields' do
    it 'can handle empty case' do
      expect(described_class.sorted_fields('', [], [])).to eq([])
    end

    it 'can return default value for empty allowed array' do
      result = described_class.sorted_fields('', [], default)
      expect(result).to eq(['created_at'])
    end

    it 'returns default value when sort param is nil' do
      result = described_class.sorted_fields(nil, [], default)
      expect(result).to eq(['created_at'])
    end

    it 'can return default case when no sort params are present' do
      result = described_class.sorted_fields('', ['updated_at'], default)
      expect(result).to eq(['created_at'])
    end

    context 'single field' do
      it 'returns correct sort params' do
        result = described_class.sorted_fields('updated_at', ['updated_at'], default)
        expect(result).to eq('updated_at' => :asc)
      end

      it 'returns correct sort params with inverted direction' do
        result = described_class.sorted_fields('-updated_at', ['updated_at'], default)
        expect(result).to eq('updated_at' => :desc)
      end

      it 'handles dashed params' do
        result = described_class.sorted_fields('-updated-at', ['updated_at'], default)
        expect(result).to eq('updated_at' => :desc)
      end
    end

    context 'mutiple field' do
      let(:allowed) { %w(updated_at created_at) }

      it 'returns correct sort params' do
        sort = 'updated_at,created_at'
        result = described_class.sorted_fields(sort, allowed, default)
        expect(result).to eq('updated_at' => :asc, 'created_at' => :asc)
      end

      it 'returns correct sort params with inverted direction' do
        sort = '-updated_at,created_at'
        result = described_class.sorted_fields(sort, allowed, default)
        expect(result).to eq('updated_at' => :desc, 'created_at' => :asc)
      end
    end

    context 'ignores non-allowed fields' do
      it 'returns correct sort params with inverted direction' do
        sort = 'updated_at,created_at'
        result = described_class.sorted_fields(sort, ['updated_at'], default)
        expect(result).to eq('updated_at' => :asc)
      end

      it 'returns correct sort params with inverted direction' do
        sort = 'updated_at,created_at'
        result = described_class.sorted_fields(sort, ['updated_at'], [])
        expect(result).to eq('updated_at' => :asc)
      end
    end
  end
end
