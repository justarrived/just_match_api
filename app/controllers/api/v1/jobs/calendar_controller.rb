# frozen_string_literal: true
module Api
  module V1
    module Jobs
      class CalendarController < BaseController
        before_action :set_job

        # TODO: Add pundit authorization
        after_action :verify_authorized, except: [:google]

        api :GET, '/jobs/:job_id/calendar/google', 'List users'
        description 'Returns a jobs google calendar.'
        example '# Response'
        def google
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
          # TODO: Wrap; #policy_scope(Job)
          @job = Job.find(params[:job_id])
        end
      end
    end
  end
end
