# frozen_string_literal: true
module MachineTranslationsService
  def self.call(translation:, languages: nil, ignore_attributes: [])
    locale = translation.locale # NOTE: This can return nil

    (languages || Language.machine_translation_languages).map do |language|
      next if locale == language.locale

      MachineTranslationService.call(
        translation: translation,
        language: language,
        ignore_attributes: ignore_attributes
      )
    end.compact
  end
end
