# frozen_string_literal: true
module CreateTranslationsService
  # Not supported by Google Translate: ti - Tigrinya, fa_AF - Dari
  IGNORE_LOCALES = %w(ti fa_AF).freeze

  def self.call(translation:)
    locale = translation.locale
    return if inligible_locale?(locale)

    model = model_for_translation(translation)
    attributes = build_model_attributes(model, translation)

    languages = Language.where(lang_code: eligible_locales(locale))
    languages.each do |language|
      language_locale = language.locale
      translated_attributes = { locale: language_locale }
      attributes.each do |name, value|
        next if value.blank?

        translated_value = GoogleTranslate.t(value, from: locale, to: language_locale)
        translated_attributes[name.to_sym] = translated_value
      end
      model.create_translation(translated_attributes, language.id)
    end
  end

  def self.eligible_locales(current_locale)
    I18n.available_locales.map(&:to_s) - (IGNORE_LOCALES << current_locale)
  end

  def self.model_for_translation(translation)
    # Translations only belong to one model, so grab the first one :)
    belongs_to_meta = translation.class.belongs_to_models.first
    translation.public_send(belongs_to_meta[:relation_name])
  end

  def self.build_model_attributes(model, translation)
    translated_fields = model.class.translated_fields.map(&:to_s)
    translation.attributes.slice(*translated_fields)
  end

  def self.inligible_locale?(locale)
    IGNORE_LOCALES.include?(locale)
  end
end
