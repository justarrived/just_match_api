# frozen_string_literal: true

require 'spec_helper'

RSpec.describe IBANAccount do
  subject { described_class.new(iban) }
  let(:valid_iban) { 'SA0380000000608010167519' }
  let(:invalid_iban) { nil }

  describe '#country_code' do
    context 'valid' do
      let(:iban) { valid_iban }

      it 'returns empty' do
        expect(subject.country_code).to eq('SA')
      end
    end

    context 'invalid' do
      let(:iban) { invalid_iban }

      it 'returns country_code' do
        expect(subject.country_code).to eq('')
      end
    end
  end

  describe '#errors' do
    context 'valid' do
      let(:iban) { valid_iban }

      it 'returns empty' do
        expect(subject.errors).to match([])
      end

      context 'ibans' do
        VALID_IBANS.each do |iban|
          subject { described_class.new(iban) }

          it "returns empty for '#{iban}' (note: ignores bad check digits)" do
            expect(subject.errors - [:bad_check_digits]).to match([])
          end
        end
      end
    end

    context 'invalid' do
      let(:iban) { invalid_iban }

      it 'returns errors' do
        expect(subject.errors).to match(%i(too_short bad_format))
      end
    end
  end

  describe '#valid?' do
    context 'valid' do
      let(:iban) { valid_iban }

      it 'returns true for valid account' do
        expect(subject.valid?).to eq(true)
      end
    end

    context 'invalid' do
      let(:iban) { invalid_iban }

      it 'returns false for invalid account' do
        expect(subject.valid?).to eq(false)
      end
    end
  end

  describe '#prettify' do
    VALID_IBANS.each do |iban|
      it "returns prettified account number for '#{iban}'" do
        expect(described_class.new(iban).prettify).to eq(iban)
      end
    end
  end

  describe '#to_s' do
    VALID_IBANS.each do |iban|
      it "returns account number for '#{iban}'" do
        expect(described_class.new(iban).to_s).to eq(iban.delete(' '))
      end
    end
  end
end
