# frozen_string_literal: true
require 'rails_helper'

RSpec.describe BitmaskField do
  describe '#to_a' do
    let(:array) { %w(value watman whatever) }
    let(:other_array) { %w(watman) }
    let(:another_array) { %w(watman whatever) }

    describe '#to_mask' do
      it 'can convert array to bitmask' do
        expect(described_class.to_mask(other_array, array)).to eq(2)
        expect(described_class.to_mask(another_array, array)).to eq(6)
      end
    end

    describe '#from_mask' do
      it 'can convert from bitmask to array' do
        expect(described_class.from_mask(2, array)).to eq(other_array)
        expect(described_class.from_mask(6, array)).to eq(another_array)
      end
    end
  end
end
