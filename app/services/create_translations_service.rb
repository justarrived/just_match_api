# frozen_string_literal: true
require 'i18n/google_translate'

class CreateTranslationsService
  def self.call(translation:, from:, languages: nil)
    source_translation_locale = translation.language&.lang_code

    (languages || Language.machine_translation_languages).each do |language|
      # NOTE: If the language has been explicitly set on the source translation, then
      # don't create an additional translation for that language
      next if source_translation_locale == language.lang_code

      if from == language.lang_code
        # Language has been detected, skip sending that to Google Translate and
        # create it from source instead
        set_translation(translation, translation.translation_attributes, language)
        next
      end

      attributes = translate_attributes(
        translation.translation_attributes,
        from: from,
        to: language.lang_code
      )

      set_translation(translation, attributes, language)
    end
  end

  def self.set_translation(translation, attributes, language)
    translation.
      translates_model.
      set_translation(attributes, language)
  end

  def self.translate_attributes(attributes, from:, to:)
    translated_attributes = {}
    attributes.each do |name, text|
      translation = GoogleTranslate.translate(text, from: from, to: to)
      translated_attributes[name] = translation.text
    end
    translated_attributes
  end
end
