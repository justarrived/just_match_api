# frozen_string_literal: true

class JobGoogleCalendarSerializer
  def self.serializable_resource(job:)
    JsonApiData.new(
      id: job.id,
      type: :google_calendar,
      attributes: {
        template_url: job.google_calendar_template_url
      }
    )
  end
end
