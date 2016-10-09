# frozen_string_literal: true
module Api
  module V1
    module Jobs
      class CalendarController < BaseController
        before_action :set_job

        api :GET, '/jobs/:job_id/calendar/google', 'List users'
        description 'Returns a jobs google calendar.'
        example '# Response'
        def google
          authorize(@job)

          response = JsonApiData.new(
            id: @job.id,
            type: :google_calendar,
            attributes: {
              template_url: @job.google_calendar_template_url
            },
            key_transform: key_transform_header
          )
          render json: response
        end

        private

        def set_job
          @job = policy_scope(Job).find(params[:job_id])
        end
      end
    end
  end
end
