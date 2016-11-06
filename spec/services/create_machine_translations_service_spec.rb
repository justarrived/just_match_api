# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CreateMachineTranslationsService do
  let(:bad_locale_translation) { FactoryGirl.build(:job_translation, locale: 'wat') }
  let(:translation) { FactoryGirl.build(:job_translation, locale: 'ar') }
  let(:languages) { [FactoryGirl.build(:language)] }

  describe '#call' do
    let(:new_translation) { FactoryGirl.build(:job_translation) }

    it 'returns translations' do
      allow(CreateMachineTranslationService).to receive(:call).and_return(new_translation)
      result = described_class.call(translation: translation, languages: languages)
      expect(result.length).to eq(1)
    end

    context 'ineligle locale' do
      it 'returns empty array' do
        expect(described_class.call(translation: bad_locale_translation)).to eq([])
      end
    end
  end

  describe '#eligible_locales' do
    it 'returns eligible locales' do
      expected = %w(sv ar fa ku ps)
      expect(described_class.eligible_locales('en')).to eq(expected)
    end
  end

  describe '#eligible_locale?' do
    context 'ineligle' do
      it 'returns false' do
        expect(described_class.eligible_locale?('asd')).to eq(false)
      end
    end

    context 'eligle' do
      it 'returns true' do
        expect(described_class.eligible_locale?('en')).to eq(true)
      end
    end
  end

  describe '#available_locales' do
    it 'returns available locales string array' do
      expected = I18n.available_locales.map(&:to_s)
      expect(described_class.available_locales). to eq(expected)
    end
  end
end
