# frozen_string_literal: true
class MachineTranslationsJob < ApplicationJob
  def perform(translation)
    MachineTranslationsService.call(translation: translation)
  end
end
