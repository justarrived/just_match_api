# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BICTool do
  subject { described_class.new(bic) }
  let(:valid_bic) { 'HANDFIHH' }
  let(:invalid_bic) { nil }

  describe '#valid?' do
    context 'valid bic' do
      let(:bic) { valid_bic }

      it 'returns true' do
        expect(subject.valid?).to eq(true)
      end
    end

    context 'invalid bic' do
      let(:bic) { invalid_bic }

      it 'returns true' do
        expect(subject.valid?).to eq(false)
      end
    end
  end

  describe '#errors' do
    context 'valid bic' do
      let(:bic) { valid_bic }

      it 'returns *no* errors' do
        expect(subject.errors).to match([])
      end
    end

    context 'invalid bic' do
      let(:bic) { invalid_bic }

      it 'returns errors' do
        expect(subject.errors).to match([:bad_format])
      end
    end

    context 'invalid country code' do
      let(:bic) { 'HANDZZHH' }

      it 'returns errors' do
        expect(subject.errors).to match([:bad_country_code])
      end
    end
  end

  describe '#country_code' do
    context 'valid bic' do
      let(:bic) { valid_bic }

      it 'returns the country code' do
        expect(subject.country_code).to eq('FI')
      end
    end

    context 'invalid bic' do
      let(:bic) { invalid_bic }

      it 'returns true' do
        expect(subject.country_code).to be_nil
      end
    end
  end
end
