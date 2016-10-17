# frozen_string_literal: true
require 'spec_helper'

RSpec.describe FrilansFinansApi::NilLogger do
  it 'has the same methods as Ruby standard lib Logger' do
    expect(described_class.instance_methods - Logger.instance_methods).to eq([])
  end

  describe '#initialize' do
    it 'can take any args' do
      expect do
        described_class.new
        described_class.new('watman')
        described_class.new(wat: 'man')
        described_class.new('wat', 'woman')
      end.to_not raise_error
    end
  end

  describe '#add' do
    it 'can take any args' do
      logger = described_class.new
      expect do
        logger.add
        logger.add('watman')
        logger.add(wat: 'man')
        logger.add('wat', 'woman')
      end.to_not raise_error
    end
  end
end
