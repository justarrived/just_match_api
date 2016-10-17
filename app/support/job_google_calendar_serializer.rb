# frozen_string_literal: true
class JobGoogleCalendarSerializer
  def self.serializeble_resource(job:, key_transform:)
    JsonApiData.new(
      id: job.id,
      type: :google_calendar,
      attributes: {
        template_url: job.google_calendar_template_url
      },
      key_transform: key_transform
    )
  end
end
