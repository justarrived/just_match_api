# frozen_string_literal: true
module EnqueueCheapTranslation
  def self.call(result)
    # TODO: Uncomment!
    # MachineTranslationsJob.perform_later(
    #   result.translation,
    #   ignore_attributes: result.changed_fields # FIXME: WTF ignore changed fields??????
    # )
    MachineTranslationsService.call(
      translation: result.translation,
      ignore_attributes: []
    )
  end
end
