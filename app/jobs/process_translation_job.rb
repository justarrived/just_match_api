# frozen_string_literal: true
class ProcessTranslationJob < ApplicationJob
  def perform(translation:)
    ProcessTranslationService.call(translation: translation)
  end
end
