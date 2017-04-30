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

          attributes = LinkedinJobsSerializer.attributes(jobs: jobs)
          if json_content_type?
            render json: attributes.as_json
          else
            render xml: attributes.to_xml
          end
        end

        private

        def verify_linkedin_sync_key
          unauthorized! if params[:auth_token].blank?
          return if AppSecrets.linkedin_sync_key == params[:auth_token]

          unauthorized!
        end

        def json_content_type?
          ['application/json', 'application/vnd.api+json'].include?(request.content_type)
        end

        def unauthorized!
          raise Pundit::NotAuthorizedError
        end
      end
    end
  end
end
