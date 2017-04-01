# frozen_string_literal: true
require 'i18n/detect_language'

class ProcessTranslationService
  CONFIDENCE_THRESHOLD = 0.50

  def self.call(translation:, changed: nil)
    text = translation.
           translation_attributes.
           values.
           join("\n\n")

    return if text.blank?

    from = translation.language&.locale || detect_locale(text, translation)
    return if from.nil?

    CreateTranslationsJob.perform_later(
      translation: translation,
      from: from,
      changed: changed
    )
  end

  def self.detect_locale(text, translation)
    detection = DetectLanguage.call(text)
    track_detection(detection, translation)
    return unless detection.valid? # Return if we "detect" an undetermined language, etc
    return unless within_confidence_level?(detection.confidence)

    detection.source_override || detection.source
  end

  def self.within_confidence_level?(confidence)
    confidence > CONFIDENCE_THRESHOLD
  end

  def self.track_detection(detection, translation)
    data = detection.to_h
    data.delete(:text) # The text can be sensitive and/or too long so don't store it
    data[:translation] = translation&.display_name
    Analytics.track(:google_translate_detection, data: data)
  end
end
