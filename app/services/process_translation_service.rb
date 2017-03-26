# frozen_string_literal: true
require 'i18n/detect_language'

class ProcessTranslationService
  def self.call(translation:, changed: nil)
    text = translation.
           translation_attributes.
           values.
           join("\n\n")

    from = translation.language&.lang_code

    if from.nil?
      detection = DetectLanguage.call(text)
      return if detection.nil?

      from = detection.source_override || detection.source
    end

    CreateTranslationsJob.perform_later(
      translation: translation,
      from: from,
      changed: changed
    )
  end
end
