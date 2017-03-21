# frozen_string_literal: true
require 'rails_helper'

RSpec.describe MachineTranslationService do
  let(:translation) { FactoryGirl.build(:job_translation) }
  let(:job) { translation.job }
  let(:name) { 'Hej' }
  let(:from_locale) { nil }
  let(:to_locale) { :sv }
  let(:google_translate_mock) do
    Struct.new(:text, :from, :to, :detected?).new(name, from_locale, to_locale, false)
  end

  describe '#call' do
    let(:language) { FactoryGirl.create(:language) }

    it 'creates translation' do
      allow(GoogleTranslate).to receive(:translate).and_return(google_translate_mock)

      result = described_class.call(translation: translation, language: language)

      translated_translation = result.translation
      expect(result.changed_fields).to eq(%w(name short_description description))
      expect(translated_translation).to be_a(JobTranslation)
      expect(translated_translation).to be_persisted
      expect(translated_translation.name).to eq(name)
      expect(translated_translation.job).to eq(translation.job)
      expect(translated_translation.locale).to eq(language.locale)
    end

    context 'with detected translation' do
      let(:google_detected_locale) { 'en' }
      let(:google_translate_mock) do
        Struct.new(:text, :from, :to, :detected?).
          new(name, google_detected_locale, to_locale, true)
      end

      it 'updates source translation to detected locale' do
        allow(GoogleTranslate).to receive(:translate).and_return(google_translate_mock)
        translation.update(language: nil, locale: nil)
        result = described_class.call(translation: translation, language: language)

        translated_translation = result.translation
        expect(result.changed_fields).to eq(%w(name short_description description))
        expect(translated_translation).to be_a(JobTranslation)
        expect(translated_translation).to be_persisted
        expect(translated_translation.name).to eq(name)
        expect(translated_translation.job).to eq(translation.job)
        expect(translation.locale).to eq(google_detected_locale)
      end
    end
  end

  describe '#remote_translate_attributes' do
    let(:from_locale) { :en }

    subject do
      allow(GoogleTranslate).to receive(:translate).and_return(google_translate_mock)
      described_class.remote_translate_attributes(
        attributes: attributes,
        from_locale: from_locale,
        to_locale: to_locale,
        ignore_attributes: ignore_attributes
      )
    end
    let(:attributes) { { name: 'Hello' } }

    context 'with *no* ignored attributes' do
      let(:ignore_attributes) { [] }

      it 'returns translated attributes hash' do
        expect(subject.attributes).to eq(name: name, locale: :sv)
      end
    end

    context 'with ignored attributes' do
      let(:ignore_attributes) { [:name] }

      it 'returns translated attributes hash' do
        expect(subject.attributes).to eq(locale: :sv)
      end
    end
  end
end
