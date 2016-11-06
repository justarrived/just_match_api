# frozen_string_literal: true
module MachineTranslationsService
  def self.call(translation:, languages: nil)
    locale = translation.locale

    (languages || Language.machine_translation_languages).map do |language|
      next if locale == language.locale

      MachineTranslationService.call(translation: translation, language: language)
    end.compact
  end
end
