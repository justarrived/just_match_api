# frozen_string_literal: true

module Api
  module V1
    module Digests
      class JobDigestSubscribersController < BaseController
        after_action :verify_authorized, only: []

        resource_description do
          api_versions '1.0'
          name 'JobDigest'
          short 'API for job digests'
          description ''
          formats [:json]
        end

        api :POST, '/digests/subscribers/', 'Create job digest subscriber'
        description 'Create job digest subscriber.'
        error code: 400, desc: 'Bad request'
        error code: 422, desc: 'Unprocessable entity'
        ApipieDocHelper.params(self)
        param :data, Hash, desc: 'Top level key', required: true do
          param :attributes, Hash, desc: 'JobDigest attributes', required: true do
            param :user_id, String, desc: 'User id (required if email is blank)'
            param :email, String, desc: 'Email (required if email is blank)'
          end
        end
        def create
          job_digest_subscriber = JobDigestSubscriber.new(job_digest_subscriber_params)

          if job_digest_subscriber.save
            api_render(job_digest_subscriber, status: :created)
          else
            api_render_errors(job_digest_subscriber)
          end
        end

        api :DELETE, '/digests/subscribers/:job_digest_id', 'Delete job digest'
        description 'Delete job digest subscriber.'
        error code: 400, desc: 'Bad request'
        error code: 404, desc: 'Not found'
        ApipieDocHelper.params(self)
        def destroy
          job_digest_subscriber = JobDigestSubscriber.find(params[:job_digest_subscriber_id]) # rubocop:disable Metrics/LineLength
          job_digest_subscriber.destroy

          head :no_content
        end

        private

        def job_digest_subscriber_params
          jsonapi_params.permit(:email, :user_id, :job_digest_id)
        end
      end
    end
  end
end
