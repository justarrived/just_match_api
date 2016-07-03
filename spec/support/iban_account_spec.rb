# frozen_string_literal: true
require 'spec_helper'

RSpec.describe IBANAccount do
  subject { described_class.new(iban) }
  let(:valid_iban) { ' ro49  aaaa 1B31007593840000 ' }
  let(:invalid_iban) { nil }

  describe '#country_code' do
    context 'valid' do
      let(:iban) { valid_iban }

      it 'returns empty' do
        expect(subject.country_code).to eq('RO')
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
    end

    context 'invalid' do
      let(:iban) { invalid_iban }

      it 'returns errors' do
        expect(subject.errors).to match([:too_short])
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
end
