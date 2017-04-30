# frozen_string_literal: true
module Api
  module V1
    module PartnerFeeds
      class JobsController < BaseController
        before_action :verify_linkedin_sync_key
        after_action :verify_authorized, except: [:linkedin]

        def linkedin
          jobs = Job.with_translations.
            includes(:company).
            order(created_at: :desc).
            limit(AppConfig.linkedin_job_records_feed_limit)

          render json: LinkedinJobsSerializer.attributes(jobs: jobs).as_json
        end

        private


        def verify_linkedin_sync_key
          unauthorized! if params[:auth_token].blank?
          return if AppSecrets.linkedin_sync_key == params[:auth_token]

          unauthorized!
        end

        def unauthorized!
          raise Pundit::NotAuthorizedError
        end
      end
    end
  end
end