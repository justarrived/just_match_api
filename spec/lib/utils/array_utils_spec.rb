# frozen_string_literal: true

require 'spec_helper'
require 'utils/array_utils'

RSpec.describe ArrayUtils do
  describe '::most_common' do
    it 'returns the most common element in the array' do
      expect(described_class.most_common([1, 2, 1, 2, 1])).to eq(1)
    end

    it 'returns the first element encountered if multiple elements occur the same amount times' do # rubocop:disable Metrics/LineLength
      expect(described_class.most_common([1, 2, 1, 2])).to eq(1)
      expect(described_class.most_common([1, 2, 2, 1])).to eq(1)
      expect(described_class.most_common([2, 1, 2, 1])).to eq(2)
      expect(described_class.most_common([3, 3, 2, 1, 2, 1])).to eq(3)
      expect(described_class.most_common([3, 3, 1, 1])).to eq(3)
    end

    it 'returns nil if passed an empty array' do
      expect(described_class.most_common([])).to be_nil
    end
  end
end
