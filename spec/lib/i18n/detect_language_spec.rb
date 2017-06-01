# frozen_string_literal: true

require 'spec_helper'

require 'i18n/detect_language'

RSpec.describe DetectLanguage do
  describe '::call' do
    let(:detection_mock) do
      Struct.new(:text, :language, :confidence, :valid?).new('Hej', 'da', 0, true)
    end

    it 'retruns detection result' do
      allow(GoogleTranslate).to receive(:detect).and_return(detection_mock)
      detection = described_class.call('Hej')
      expect(detection.confidence).to be_zero
      expect(detection.text).to eq('Hej')
      expect(detection.source).to eq('da')
      expect(detection.source_override).to eq('sv')
    end
  end

  describe '#source_override' do
    subject { described_class.new('Hej') }

    it 'overrides certain locales if within override confidence threshold' do
      expect(subject.source_override('da', 0.10)).to eq('sv')
    end

    it 'does *not* override locale if not within override confidence threshold' do
      expect(subject.source_override('da', 0.90)).to be_nil
    end

    it 'does *not* override locale if locale has no override mapping' do
      expect(subject.source_override('en', 0.10)).to be_nil
    end
  end

  describe '#within_override_confidence_threshold?' do
    subject { described_class.new('Hej') }

    it 'returns true when confidence is sufficiently low for an override' do
      result = subject.within_override_confidence_threshold?(0.10)
      expect(result).to eq(true)
    end

    it 'returns false when confidence is too great for an override' do
      result = subject.within_override_confidence_threshold?(0.80)
      expect(result).to eq(false)
    end
  end
end
