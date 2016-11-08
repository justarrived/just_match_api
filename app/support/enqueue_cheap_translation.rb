# frozen_string_literal: true
module EnqueueCheapTranslation
  def self.call(result)
    MachineTranslationsJob.perform_later(
      result.translation,
      ignore_attributes: result.changed_fields
    )
  end
end
