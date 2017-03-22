# frozen_string_literal: true
module MachineTranslationsService
  def self.call(translation:, languages: nil, ignore_attributes: [])
    (languages || Language.machine_translation_languages).map do |language|
      next if translation.locale == language.locale

      MachineTranslationService.call(
        translation: translation,
        language: language,
        ignore_attributes: ignore_attributes
      )
    end.compact
  end
end
