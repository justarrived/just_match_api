# frozen_string_literal: true
class MachineTranslationsJob < ApplicationJob
  def perform(translation)
    CreateMachineTranslationsService.call(translation: translation)
  end
end
