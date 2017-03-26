# frozen_string_literal: true
class CreateTranslationsJob < ApplicationJob
  def perform(translation:, from:, changed: [], languages: nil)
    CreateTranslationsService.call(
      translation: translation,
      from: from,
      changed: changed,
      languages: languages
    )
  end
end
