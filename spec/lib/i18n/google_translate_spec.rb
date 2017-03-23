# frozen_string_literal: true
require 'spec_helper'
require 'i18n/google_translate'

RSpec.describe GoogleTranslate do
  let(:text) { 'Hello' }

  describe '#translate' do
    let(:translated_text) { 'Hej' }
    let(:google_translate_mock) do
      Class.new(Struct.new(:key)) do
        def self.translate(*_args)
          Struct.new(:text).new('Hej')
        end
      end
    end

    subject do
      allow(Google::Cloud::Translate).to receive(:new).and_return(google_translate_mock)
      described_class
    end

    it 'translanslates the given text' do
      result = subject.translate(text, from: :en, to: :sv, api_key: 'xxx')
      expect(result.text).to eq(translated_text)
    end

    describe '#t' do
      it 'produces the same result as #translate' do
        translate_result = subject.translate(text, from: :en, to: :sv, api_key: 'xxx')
        t_result = subject.t(text, from: :en, to: :sv)
        expect(t_result.text).to eq(translate_result.text)
      end
    end
  end

  describe '#detect' do
    let(:google_translate_detection_mock) do
      Class.new(Struct.new(:key)) do
        def self.detect(*_args)
          Struct.new(:text, :confidence, :language).new('Hej', 0.46, 'sv')
        end
      end
    end

    subject do
      allow(Google::Cloud::Translate).to receive(:new).
        and_return(google_translate_detection_mock)
      described_class
    end

    it 'detects the source language' do
      result = subject.detect(text)
      expect(result.language).to eq('sv')
    end
  end
end
