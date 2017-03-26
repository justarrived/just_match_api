# frozen_string_literal: true
require 'i18n/google_translate'

class CreateTranslationsService
  def self.call(translation:, from:, changed: nil, languages: nil)
    source_translation_locale = translation.language&.locale

    (languages || Language.machine_translation_languages).map do |language|
      # NOTE: If the language has been explicitly set on the source translation, then
      # don't create an additional translation for that language
      next if source_translation_locale == language.locale

      attributes = attributes_for_translation(translation, changed)

      if from == language.locale
        # Language has been detected, skip sending that to Google Translate and
        # create it from source instead
        next set_translation(translation, attributes, language)
      end

      translated_attributes = translate_attributes(
        attributes,
        from: from,
        to: language.locale
      )

      set_translation(translation, translated_attributes, language)
    end.compact
  end

  def self.attributes_for_translation(translation, changed)
    attributes = translation.translation_attributes
    # If changed is nil then all fields will be translated
    return attributes unless changed
    attributes.slice(*changed)
  end

  def self.set_translation(translation, attributes, language)
    translation.
      translates_model.
      set_translation(attributes, language)
  end

  def self.translate_attributes(attributes, from:, to:)
    translated_attributes = {}
    attributes.each do |name, text|
      translation = GoogleTranslate.translate(text, from: from, to: to, type: :plain)
      translated_attributes[name] = translation.text
    end
    translated_attributes
  end
end
