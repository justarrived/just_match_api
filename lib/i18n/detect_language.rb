# frozen_string_literal: true
require 'i18n/google_translate'

module DetectLanguage
  LanguageDetectionResult = Struct.new(:text, :confidence, :source)

  def self.call(text)
    detection = GoogleTranslate.detect(text)
    return unless detection.confidence > 70

    LanguageDetectionResult.new(text, detection.confidence, detection.language)
  end
end
