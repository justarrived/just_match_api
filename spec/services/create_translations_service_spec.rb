# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateTranslationsService do
  describe '::call' do
    before(:each) do
      google_translate_mock = Struct.new(:text).new('Taw')
      allow(GoogleTranslate).to receive(:translate).and_return(google_translate_mock)
    end

    it 'does not create duplicate translations' do
      language = FactoryGirl.create(:language)
      translation = FactoryGirl.create(:message_translation, language: language)
      result = described_class.call(
        translation: translation, from: :sv, languages: [language]
      )
      expect(result).to be_empty
    end

    context 'translation language unknown' do
      it 'creates translation' do
        translation = FactoryGirl.create(:message_translation, language: nil)
        result = described_class.call(
          translation: translation, from: :sv, languages: [FactoryGirl.create(:language)]
        )
        expect(result.first.translation.body).to eq('Taw')
      end
    end
  end

  describe '::attributes_for_translation' do
    context 'when changed arg is nil' do
      it 'returns all attributes' do
        message_body = 'Watman'
        translation = FactoryGirl.create(:message_translation, body: message_body)
        attributes = described_class.attributes_for_translation(translation, nil)
        expect(attributes).to eq('body' => message_body)
      end
    end

    it 'returns all attributes in changed array (of strings)' do
      name = 'Watman'
      translation = FactoryGirl.create(:job_translation, name: name)
      attributes = described_class.attributes_for_translation(translation, %w(name))
      expect(attributes).to eq('name' => name)
    end

    it 'returns all attributes in changed array (of symbols)' do
      name = 'Watman'
      translation = FactoryGirl.create(:job_translation, name: name)
      attributes = described_class.attributes_for_translation(translation, %i(name))
      expect(attributes).to eq('name' => name)
    end
  end

  describe '::set_translation' do
    it 'creates a translation' do
      translation = FactoryGirl.create(:message_translation, body: 'Watman')
      language = FactoryGirl.create(:language)
      expect do
        described_class.set_translation(
          translation,
          translation.translation_attributes,
          language
        )
      end.to change(MessageTranslation, :count).by(1)
    end
  end

  describe '::translate_attributes' do
    it 'translates each attribute in hash' do
      expected = 'Taw'
      google_translate_mock = Struct.new(:text).new(expected)
      allow(GoogleTranslate).to receive(:translate).and_return(google_translate_mock)
      attributes = { title: 'Wat', subtitle: 'Wat' }
      translated = described_class.translate_attributes(attributes, from: :sv, to: :en)
      expect(translated).to eq(title: expected, subtitle: expected)
    end
  end

  describe '::translate_text' do
    it 'returns nil if text is blank' do
      expect(described_class.translate_text('   ', from: :sv, to: :en)).to be_nil
    end

    it 'returns translated text' do
      expected = 'Taw'
      google_translate_mock = Struct.new(:text).new(expected)
      allow(GoogleTranslate).to receive(:translate).and_return(google_translate_mock)

      translated_text = described_class.translate_text('Wat', from: :sv, to: :en)
      expect(translated_text).to eq(expected)
    end
  end
end
