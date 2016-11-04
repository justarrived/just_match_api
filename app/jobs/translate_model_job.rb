# frozen_string_literal: true
require 'i18n/google_translate'

class TranslateModelJob < ApplicationJob
  def perform(translation)
    CreateTranslationsService.call(translation: translation)
  end
end
