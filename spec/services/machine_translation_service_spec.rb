# frozen_string_literal: true
require 'rails_helper'

RSpec.describe MachineTranslationService do
  let(:translation) { FactoryGirl.build(:job_translation) }
  let(:job) { translation.job }

  describe '#call' do
    let(:language) { FactoryGirl.create(:language) }

    it 'creates translation' do
      allow(GoogleTranslate).to receive(:t).and_return('Hej')

      result = described_class.call(translation: translation, language: language)

      expect(result).to be_a(JobTranslation)
      expect(result).to be_persisted
      expect(result.name).to eq('Hej')
      expect(result.job).to eq(translation.job)
      expect(result.locale).to eq(language.locale)
    end
  end

  describe '#build_translation_attributes' do
    it 'returns translated attributes hash' do
      allow(GoogleTranslate).to receive(:t).and_return('Hej')

      attributes = { name: 'Hello' }
      result = described_class.build_translation_attributes(
        attributes: attributes,
        from_locale: :en,
        to_locale: :sv
      )
      expect(result).to eq(name: 'Hej', locale: :sv)
    end
  end
end
