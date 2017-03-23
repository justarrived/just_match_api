# frozen_string_literal: true
class CreateTranslationsJob < ApplicationJob
  def perform(translation:, from:, languages: nil)
    CreateTranslationsService.call(
      translation: translation,
      from: from,
      languages: languages
    )
  end
end
