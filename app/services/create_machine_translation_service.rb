# frozen_string_literal: true
require 'i18n/google_translate'

module CreateMachineTranslationService
  def self.call(translation:, language:)
    locale = translation.locale
    model = model_for_translation(translation)
    attributes = build_model_attributes(model, translation)

    translated_attributes = build_translate_attributes(
      attributes: attributes,
      from_locale: locale,
      to_locale: language.locale
    )

    model.create_translation(translated_attributes, language.id)
  end

  def self.build_translate_attributes(attributes:, from_locale:, to_locale:)
    translated_attributes = { locale: to_locale }
    attributes.each do |name, text|
      next if text.blank?

      translated_text = GoogleTranslate.t(text, from: from_locale, to: to_locale)
      translated_attributes[name.to_sym] = translated_text
    end
    translated_attributes
  end

  def self.model_for_translation(translation)
    # NOTE: Translations only belong to one model, so grab the first one
    belongs_to_meta = translation.class.belongs_to_models.first
    translation.public_send(belongs_to_meta[:relation_name])
  end

  def self.build_model_attributes(model, translation)
    translated_fields = model.class.translated_fields.map(&:to_s)
    translation.attributes.slice(*translated_fields)
  end
end
