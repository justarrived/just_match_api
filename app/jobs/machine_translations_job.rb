# frozen_string_literal: true
class MachineTranslationsJob < ApplicationJob
  def perform(translation, ignore_attributes: [])
    MachineTranslationsService.call(
      translation: translation,
      ignore_attributes: ignore_attributes.map(&:to_sym)
    )
  end
end
