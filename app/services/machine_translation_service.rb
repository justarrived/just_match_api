# frozen_string_literal: true
require 'i18n/google_translate'

module MachineTranslationService
  def self.call(translation:, language:)
    translated_attributes = build_translation_attributes(
      attributes: translation.translation_attributes,
      from_locale: translation.locale,
      to_locale: language.locale
    )

    translation.
      translates_model.
      set_translation(translated_attributes, language.id)
  end

  def self.build_translation_attributes(attributes:, from_locale:, to_locale:)
    translated_attributes = { locale: to_locale }
    attributes.each do |name, text|
      unless text.blank?
        translated_text = GoogleTranslate.t(text, from: from_locale, to: to_locale)
      end

      translated_attributes[name.to_sym] = translated_text
    end
    translated_attributes
  end
end
