# frozen_string_literal: true
require 'i18n/google_translate'

module MachineTranslationService
  def self.call(translation:, language:, ignore_attributes: [])
    translated_attributes = build_translation_attributes(
      attributes: translation.translation_attributes,
      from_locale: translation.locale,
      to_locale: language.locale,
      ignore_attributes: ignore_attributes
    )

    translation.
      translates_model.
      set_translation(translated_attributes, language.id)
  end

  def self.build_translation_attributes(attributes:, from_locale:, to_locale:, ignore_attributes:) # rubocop:disable Metrics/LineLength
    translated_attributes = { locale: to_locale }
    attributes.each do |name, text|
      name_symbol = name.to_sym
      next if ignore_attributes.include?(name_symbol)

      unless text.blank?
        translated_text = GoogleTranslate.t(text, from: from_locale, to: to_locale)
      end

      translated_attributes[name_symbol] = translated_text
    end
    translated_attributes
  end
end
