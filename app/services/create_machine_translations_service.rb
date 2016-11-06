# frozen_string_literal: true
module CreateMachineTranslationsService
  def self.call(translation:, languages: nil)
    locale = translation.locale

    (languages || Language.machine_translation_languages).map do |language|
      next if locale == language.locale

      CreateMachineTranslationService.call(translation: translation, language: language)
    end.compact
  end
end
