# frozen_string_literal: true
class TranslateModelJob < ApplicationJob
  def perform(translation)
    CreateTranslationsService.call(translation: translation)
  end
end
