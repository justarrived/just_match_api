# frozen_string_literal: true
require 'i18n/google_translate'

module DetectLanguage
  LanguageDetectionResult = Struct.new(:text, :confidence, :source, :source_override)

  MIN_CONFIDENCE_LEVEL_FOR_TRANSLATIONS = 0.50

  def self.call(text)
    detection = GoogleTranslate.detect(text)
    return unless within_confidence_level?(detection.confidence)

    LanguageDetectionResult.new(
      text, detection.confidence, detection.language, source_override(detection.language)
    )
  end

  def self.source_override(locale)
    return 'sv' if %w(no da).include?(locale.to_s)
    nil
  end

  def self.within_confidence_level?(confidence)
    confidence > MIN_CONFIDENCE_LEVEL_FOR_TRANSLATIONS
  end
end
