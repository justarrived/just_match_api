# frozen_string_literal: true
require 'i18n/google_translate'

module DetectLanguage
  LanguageDetectionResult = Struct.new(:text, :confidence, :source, :source_override)

  OVERRIDE_CONFIDENCE_THRESHOLD = 0.60

  def self.call(text)
    detection = GoogleTranslate.detect(text)

    override_language = source_override(detection.language, detection.confidence)
    LanguageDetectionResult.new(
      text, detection.confidence, detection.language, override_language
    )
  end

  def self.source_override(locale, confidence)
    return unless within_override_confidence_threshold?(confidence)
    return 'sv' if %w(no da).include?(locale.to_s)
    nil
  end

  def self.within_override_confidence_threshold?(confidence)
    confidence < OVERRIDE_CONFIDENCE_THRESHOLD
  end
end
