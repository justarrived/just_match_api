# frozen_string_literal: true

require 'spec_helper'

RSpec.describe PhoneNumber do
  describe '#normalize' do
    it 'normalizes a given number' do
      expect(described_class.normalize('0735 -000 0000')).to eq('+467350000000')
    end

    it 'returns nil when passed a number thats nil' do
      expect(described_class.normalize(nil)).to be_nil
    end

    it 'returns the number untouched when passed an invalid number' do
      expect(described_class.normalize('073')).to eq('073')
    end
  end

  describe '#valid?' do
    context 'invalid' do
      let(:invalid_number) { '000123456789' }

      it 'returns false' do
        expect(described_class.valid?(invalid_number)).to eq(false)
      end
    end

    context 'valid' do
      let(:valid_number) { '+46735000000' }

      it 'returns true' do
        expect(described_class.valid?(valid_number)).to eq(true)
      end
    end
  end

  describe '#valid?' do
    context 'non Swedish number' do
      let(:invalid_number) { '+447350000000' }

      it 'returns false' do
        expect(described_class.swedish_number?(invalid_number)).to eq(false)
      end
    end

    context 'Swedish number' do
      let(:valid_number) { '+46735000000' }

      it 'returns true' do
        expect(described_class.swedish_number?(valid_number)).to eq(true)
      end
    end
  end
end
