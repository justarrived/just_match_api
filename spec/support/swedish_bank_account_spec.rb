# frozen_string_literal: true
require 'spec_helper'

RSpec.describe SwedishBankAccount do
  let(:valid_account) { ' 11000000000 ' }
  let(:invalid_account) { ' 001X ' }

  describe '#errors' do
    context 'valid account' do
      subject { described_class.new(valid_account).errors }

      it 'returns empty errors list' do
        expect(subject).to be_empty
      end
    end

    context 'invalid account' do
      subject { described_class.new(invalid_account).errors }

      it 'returns list of errors' do
        expected = [:too_short, :invalid_characters, :unknown_clearing_number]
        expect(subject).to match(expected)
      end

      context 'thats nil' do
        let(:invalid_account) { nil }

        it 'returns list of errors' do
          expected = [:too_short, :unknown_clearing_number]
          expect(subject).to match(expected)
        end
      end
    end
  end

  describe '#normalize' do
    context 'valid account' do
      subject { described_class.new(valid_account) }

      it 'returns clearing number' do
        expect(subject.clearing_number).to eq('1100')
      end

      it 'returns serial number' do
        expect(subject.serial_number).to eq('0000000')
      end

      it 'returns bank' do
        expect(subject.bank).to eq('Nordea')
      end

      it 'returns true for #valid?' do
        expect(subject.valid?).to eq(true)
      end
    end

    context 'invalid account' do
      subject { described_class.new(invalid_account) }

      it 'returns clearing number' do
        expect(subject.clearing_number).to eq('001')
      end

      it 'returns serial number' do
        expect(subject.serial_number).to eq('')
      end

      it 'returns bank' do
        expect(subject.bank).to be_nil
      end

      it 'returns false for #valid?' do
        expect(subject.valid?).to eq(false)
      end
    end
  end
end
