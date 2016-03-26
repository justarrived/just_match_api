# frozen_string_literal: true
require 'spec_helper'

RSpec.describe SafeDig do
  describe '#dig' do
    it 'works for empty hash' do
      expect(described_class.dig({}, :name, :test)).to be_nil
    end

    it 'returns nil when there is *not* such a nested key' do
      hash = { name: {} }
      expect(described_class.dig(hash, :name, :test)).to be_nil
    end

    it 'returns nil when there is *not* such a nested key' do
      hash = { name: '' }
      expect(described_class.dig(hash, :name, :test)).to be_nil
    end

    it 'returns nested key value' do
      hash = { name: { test: 'watman' } }
      expect(described_class.dig(hash, :name, :test)).to eq('watman')
    end
  end
end
