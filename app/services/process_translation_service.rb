# frozen_string_literal: true
require 'i18n/detect_language'

class ProcessTranslationService
  CONFIDENCE_THRESHOLD = 0.50

  def self.call(translation:, changed: nil)
    text = translation.
           translation_attributes.
           values.
           join("\n\n")

    from = translation.language&.locale

    if from.nil?
      detection = DetectLanguage.call(text)
      return unless within_confidence_level?(detection.confidence)

      from = detection.source_override || detection.source
    end

    CreateTranslationsJob.perform_later(
      translation: translation,
      from: from,
      changed: changed
    )
  end

  def self.within_confidence_level?(confidence)
    confidence > CONFIDENCE_THRESHOLD
  end
end
