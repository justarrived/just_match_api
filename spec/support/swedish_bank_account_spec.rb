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
        expected = %i(too_short invalid_characters unknown_clearing_number)
        expect(subject).to match(expected)
      end

      context 'thats nil' do
        let(:invalid_account) { nil }

        it 'returns list of errors' do
          expected = %i(too_short unknown_clearing_number)
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

  describe '#errors_by_field' do
    let(:test_datum) do
      [
        [:account, %i(too_short invalid_characters)],
        [:clearing_number, [:unknown_clearing_number]],
        [:serial_number, []]
      ]
    end

    subject { described_class.new('åäö') }

    it 'yields errors for each field' do
      cycle = [0, 1, 2].cycle
      subject.errors_by_field do |field, errors|
        test_data = test_datum[cycle.next]

        expect(test_data.first).to eq(field)
        expect(test_data.last).to eq(errors)
      end
    end

    it 'returns pair of errors for each field' do
      expected = [:account, %i(too_short invalid_characters)]
      expect(subject.errors_by_field.first).to eq(expected)
    end
  end

  describe '#errors_for' do
    subject { described_class.new('åäö') }

    [
      [:serial_number, []],
      [:account, %i(too_short invalid_characters)],
      [:clearing_number, [:unknown_clearing_number]]
    ].each do |test_data|
      field = test_data.first
      expected = test_data.last

      it "only selects errors for #{field}" do
        expect(subject.errors_for(field)).to eq(expected)
      end
    end
  end

  describe '#known_error_for' do
    subject { described_class.new(nil) }

    [
      [:account, %i(invalid_characters too_short too_long)],
      [:serial_number, [:bad_checksum]],
      [:clearing_number, [:unknown_clearing_number]]
    ].each do |test_data|
      field = test_data.first
      expected = test_data.last

      it "returns known error list for #{field}" do
        result = subject.known_errors_for(field)
        expect(result).to eq(expected)
      end
    end

    it 'raises exception if passed unknown field' do
      expect do
        subject.known_errors_for(:watman)
      end.to raise_error(SwedishBankAccount::UnknownErrorType)
    end
  end
end
