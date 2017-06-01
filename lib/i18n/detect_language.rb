# frozen_string_literal: true

require 'i18n/google_translate'

class DetectLanguage
  UNDETERMINED_LANGUAGE_CODE = 'und'
  OVERRIDE_CONFIDENCE_THRESHOLD = 0.60

  LanguageDetectionResult = Struct.new(
    :text, :confidence, :source, :source_override, :valid?
  )

  def self.call(text)
    new(text).call
  end

  attr_reader :text

  def initialize(text)
    @text = text
  end

  def call
    detection = GoogleTranslate.detect(text)

    valid = true
    valid = false if detection.language == UNDETERMINED_LANGUAGE_CODE

    override_language = source_override(detection.language, detection.confidence)
    LanguageDetectionResult.new(
      text, detection.confidence, detection.language, override_language, valid
    )
  end

  def source_override(locale, confidence)
    return unless within_override_confidence_threshold?(confidence)
    return 'sv' if %w(no da).include?(locale.to_s)
    nil
  end

  def within_override_confidence_threshold?(confidence)
    confidence < OVERRIDE_CONFIDENCE_THRESHOLD
  end
end
