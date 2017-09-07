# frozen_string_literal: true

module Api
  module V1
    module Jobs
      class CalendarController < BaseController
        before_action :set_job

        api :GET, '/jobs/:job_id/calendar/google', 'List users'
        description 'Returns a jobs google calendar.'
        # rubocop:disable Metrics/LineLength
        example '{
  "data": {
    "id": 1,
    "type": "google-calendar",
    "attributes": {
      "template-url": "https://www.google.com/calendar/render?action=TEMPLATE&text=Dr.%20Hans%20Olsson&dates=20160628T160756Z/20160628T220000Z&details=Keffiyeh%20fap%20shabby%20chic.%20Bushwick%20organic%20distillery%20poutine%20craft%20beer.%20Chambray%20heirloom%20direct%20trade.&location=Stora%20Nygatan%2012,%2021137&sf=true&output=xml"
    }
  }
}'
        # rubocop:enable Metrics/LineLength
        def google
          authorize(@job)

          serialized_data = JobGoogleCalendarSerializer.serializable_resource(
            job: @job
          )
          render json: serialized_data
        end

        private

        def set_job
          @job = policy_scope(Job).find(params[:job_id])
        end
      end
    end
  end
end
