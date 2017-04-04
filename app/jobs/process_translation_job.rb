# frozen_string_literal: true
class ProcessTranslationJob < ApplicationJob
  def perform(translation:, changed: nil)
    ProcessTranslationService.call(
      translation: translation,
      changed: changed
    )
  end
end
