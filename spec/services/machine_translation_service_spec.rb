# frozen_string_literal: true
require 'rails_helper'

RSpec.describe MachineTranslationService do
  let(:translation) { FactoryGirl.build(:job_translation) }
  let(:job) { translation.job }
  let(:name) { 'Hej' }

  describe '#call' do
    let(:language) { FactoryGirl.create(:language) }

    it 'creates translation' do
      allow(GoogleTranslate).to receive(:t).and_return(name)

      result = described_class.call(translation: translation, language: language)

      translation = result.translation
      expect(result.changed_fields).to eq(%w(name short_description description))
      expect(translation).to be_a(JobTranslation)
      expect(translation).to be_persisted
      expect(translation.name).to eq(name)
      expect(translation.job).to eq(translation.job)
      expect(translation.locale).to eq(language.locale)
    end
  end

  describe '#build_translation_attributes' do
    subject do
      allow(GoogleTranslate).to receive(:t).and_return(name)
      described_class.build_translation_attributes(
        attributes: attributes,
        from_locale: :en,
        to_locale: :sv,
        ignore_attributes: ignore_attributes
      )
    end
    let(:attributes) { { name: 'Hello' } }

    context 'with *no* ignored attributes' do
      let(:ignore_attributes) { [] }

      it 'returns translated attributes hash' do
        expect(subject).to eq(name: name, locale: :sv)
      end
    end

    context 'with ignored attributes' do
      let(:ignore_attributes) { [:name] }

      it 'returns translated attributes hash' do
        expect(subject).to eq(locale: :sv)
      end
    end
  end
end
