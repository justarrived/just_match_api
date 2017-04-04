# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProcessTranslationService do
  let(:detection_struct) do
    Struct.new(:source, :source_override, :confidence, :valid?)
  end

  describe '::call' do
    it 'returns nil for blank text' do
      translation = FactoryGirl.create(:message_translation, body: '  ')
      expect(described_class.call(translation: translation)).to be_nil
    end

    it 'returns nil if source language can not be determined' do
      detection = detection_struct.new('en', 'en', 1, false)
      translation = FactoryGirl.create(:message_translation, language: nil)
      allow(DetectLanguage).to receive(:call).and_return(detection)

      expect(described_class.call(translation: translation)).to be_nil
    end

    it 'enqueues create translations job' do
      detection = detection_struct.new('en', 'en', 1, true)
      translation = FactoryGirl.create(:message_translation, language: nil)
      allow(DetectLanguage).to receive(:call).and_return(detection)

      job_args = { translation: translation, from: 'en', changed: nil }
      expect do
        described_class.call(translation: translation)
      end.to have_enqueued_job(CreateTranslationsJob).with(**job_args)
    end
  end

  describe '::detect_locale' do
    let(:translation) { FactoryGirl.build(:message_translation) }

    it 'returns detected locale if it can be determined' do
      detection = detection_struct.new('en', 'en', 1, true)
      allow(DetectLanguage).to receive(:call).and_return(detection)
      expect(described_class.detect_locale('Hej', translation)).to eq('en')
    end

    it 'returns nil if locale is not over confidence threshold' do
      detection = detection_struct.new('en', 'en', 0.1, true)
      allow(DetectLanguage).to receive(:call).and_return(detection)
      expect(described_class.detect_locale('Hej', translation)).to eq(nil)
    end

    it 'returns nil if no locale could be determined' do
      detection = detection_struct.new('en', 'en', 0.1, false)
      allow(DetectLanguage).to receive(:call).and_return(detection)
      expect(described_class.detect_locale('Hej', translation)).to be_nil
    end

    it 'creates track event' do
      detection = detection_struct.new('en', 'en', 0.1, false)
      allow(DetectLanguage).to receive(:call).and_return(detection)
      expect do
        described_class.detect_locale('Hej', translation)
      end.to change(Ahoy::Event, :count).by(1)
    end
  end

  describe '::track_detection' do
    let(:translation) { FactoryGirl.build(:message_translation) }

    it 'creates detection event' do
      expect do
        described_class.track_detection({ name: 'Name', text: 'text' }, translation)
      end.to change(Ahoy::Event, :count).by(1)
    end
  end

  describe '::within_confidence_level?' do
    it 'returns false for 0.4' do
      expect(described_class.within_confidence_level?(0.4)).to eq(false)
    end

    it 'returns true for 0.65' do
      expect(described_class.within_confidence_level?(0.65)).to eq(true)
    end
  end
end
