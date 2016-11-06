# frozen_string_literal: true
module CreateMachineTranslationsService
  # Not supported by Google Translate: ti - Tigrinya, fa_AF - Dari
  IGNORE_LOCALES = %w(ti fa_AF).freeze

  def self.call(translation:, languages: nil)
    locale = translation.locale
    return [] unless eligible_locale?(locale)

    (
      languages || Language.where(lang_code: eligible_locales(locale))
    ).map do |language|
      CreateMachineTranslationService.call(translation: translation, language: language)
    end
  end

  def self.eligible_locales(current_locale)
    available_locales - (IGNORE_LOCALES + [current_locale])
  end

  def self.eligible_locale?(locale)
    available_locales.include?(locale) && IGNORE_LOCALES.exclude?(locale)
  end

  def self.available_locales
    I18n.available_locales.map(&:to_s)
  end
end
