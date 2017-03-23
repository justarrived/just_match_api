# frozen_string_literal: true
require 'i18n/google_translate'

module DetectLanguage
  LanguageDetectionResult = Struct.new(:text, :confidence, :source, :source_override)

  def self.call(text)
    detection = GoogleTranslate.detect(text)
    return if detection.confidence < 0.70 # TODO: Figure out a resonable value for this

    LanguageDetectionResult.new(
      text, detection.confidence, detection.language, source_override(detection.language)
    )
  end

  def self.source_override(locale)
    return 'sv' if %w(no da).include?(locale.to_s)
    nil
  end
end
