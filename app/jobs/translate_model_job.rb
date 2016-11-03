# frozen_string_literal: true
require 'i18n/google_translate'

class TranslateModelJob < ApplicationJob
  def perform(translation)
    # Not supported by Google Translate: ti - Tigrinya, fa_AF - Dari
    ignore_locales = %w(ti fa_AF)
    locale = translation.locale
    return if ignore_locales.include?(locale)

    locales = I18n.available_locales.map(&:to_s) - (ignore_locales << translation.locale)
    languages = Language.where(lang_code: locales)

    # Translations only belong to one model, so grab the first one :)
    belongs_to_meta = translation.class.belongs_to_models.first
    model_klass = belongs_to_meta[:model_klass]
    model = translation.public_send(belongs_to_meta[:relation_name])

    translated_fields = model.class.translated_fields.map(&:to_s)
    attributes = translation.attributes.slice(*translated_fields)

    languages.each do |language|
      translated_attributes = {}
      attributes.each do |name, value|
        next if value.blank?

        translated_value = GoogleTranslate.t(value, from: locale, to: language.lang_code)
        translated_attributes[name.to_sym] = translated_value
      end
      translated_attributes[:locale] = language.lang_code
      model.create_translation(translated_attributes, language.id)
    end
  end
end
