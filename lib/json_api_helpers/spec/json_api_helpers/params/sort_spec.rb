# frozen_string_literal: true
require 'spec_helper'

RSpec.describe JsonApiHelpers::Params::Sort do
  let(:default) { %w(created_at) }

  describe '#build' do
    it 'can handle empty case' do
      expect(described_class.build('', [], [])).to eq([])
    end

    it 'can return default value for empty allowed array' do
      result = described_class.build('', [], default)
      expect(result).to eq(['created_at'])
    end

    it 'returns default value when sort param is nil' do
      result = described_class.build(nil, [], default)
      expect(result).to eq(['created_at'])
    end

    it 'can return default case when no sort params are present' do
      result = described_class.build('', ['updated_at'], default)
      expect(result).to eq(['created_at'])
    end

    context 'single field' do
      it 'returns correct sort params' do
        result = described_class.build('updated_at', ['updated_at'], default)
        expect(result).to eq('updated_at' => :asc)
      end

      it 'returns correct sort params with inverted direction' do
        result = described_class.build('-updated_at', ['updated_at'], default)
        expect(result).to eq('updated_at' => :desc)
      end

      it 'handles dashed params' do
        result = described_class.build('-updated-at', ['updated_at'], default)
        expect(result).to eq('updated_at' => :desc)
      end
    end

    context 'mutiple field' do
      let(:allowed) { %w(updated_at created_at) }

      it 'returns correct sort params' do
        sort = 'updated_at,created_at'
        result = described_class.build(sort, allowed, default)
        expect(result).to eq('updated_at' => :asc, 'created_at' => :asc)
      end

      it 'returns correct sort params with inverted direction' do
        sort = '-updated_at,created_at'
        result = described_class.build(sort, allowed, default)
        expect(result).to eq('updated_at' => :desc, 'created_at' => :asc)
      end
    end

    context 'ignores non-allowed fields' do
      it 'returns correct sort params with inverted direction' do
        sort = 'updated_at,created_at'
        result = described_class.build(sort, ['updated_at'], default)
        expect(result).to eq('updated_at' => :asc)
      end

      it 'returns correct sort params with inverted direction' do
        sort = 'updated_at,created_at'
        result = described_class.build(sort, ['updated_at'], [])
        expect(result).to eq('updated_at' => :asc)
      end
    end
  end
end
