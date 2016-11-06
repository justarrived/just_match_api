# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CreateTranslationService do
  let(:translation) do
    FactoryGirl.build(
      :job_translation,
      name: 'Wat',
      short_description: 'Short',
      description: 'Desc'
    )
  end
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

  describe '#build_translate_attributes' do
    it 'returns translated attributes hash' do
      allow(GoogleTranslate).to receive(:t).and_return('Hej')

      attributes = { name: 'Hello' }
      result = described_class.build_translate_attributes(
        attributes: attributes,
        from_locale: :en,
        to_locale: :sv
      )
      expect(result).to eq(name: 'Hej', locale: :sv)
    end
  end

  describe '#model_for_translation' do
    it 'returns job model' do
      expect(described_class.model_for_translation(translation)).to be_a(Job)
    end
  end

  describe '#build_model_attributes' do
    it 'returns model attributes' do
      result = described_class.build_model_attributes(job, translation)
      expected = {
        'name' => 'Wat',
        'short_description' => 'Short',
        'description' => 'Desc'
      }
      expect(result).to eq(expected)
    end
  end
end
