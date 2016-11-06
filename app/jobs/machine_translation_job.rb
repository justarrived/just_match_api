# frozen_string_literal: true
class MachineTranslationJob < ApplicationJob
  def perform(translation)
    CreateMachineTranslationsService.call(translation: translation)
  end
end
