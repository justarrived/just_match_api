# frozen_string_literal: true

module Api
  module V1
    module Digests
      class JobDigestSubscribersController < BaseController
        after_action :verify_authorized, except: %i(show create destroy)

        before_action :set_subscriber, only: %i(show destroy)

        resource_description do
          api_versions '1.0'
          name 'Job digest subscriber'
          short 'API for job digest subscribers'
          description ''
          formats [:json]
        end

        api :GET, '/digests/subscribers/:job_digest_subscriber_uuid', 'Show job digest subscriber' # rubocop:disable Metrics/LineLength
        description 'Show job digest subscriber.'
        ApipieDocHelper.params(self)
        example Doxxer.read_example(JobDigestSubscriber)
        def show
          api_render(@subscriber)
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
          email = EmailAddress.normalize(jsonapi_params[:email].presence)
          user_id = jsonapi_params[:user_id].presence

          subscriber = initialize_subscriber(email, user_id)

          if subscriber.save
            api_render(subscriber, status: :created)
          else
            api_render_errors(subscriber)
          end
        end

        api :DELETE, '/digests/subscribers/:job_digest_subscriber_uuid', 'Delete job digest' # rubocop:disable Metrics/LineLength
        description 'Delete job digest subscriber.'
        error code: 400, desc: 'Bad request'
        error code: 404, desc: 'Not found'
        ApipieDocHelper.params(self)
        def destroy
          uuid = params[:job_digest_subscriber_id]
          job_digest_subscriber = JobDigestSubscriber.find_by!(uuid: uuid)
          job_digest_subscriber.destroy!

          head :no_content
        end

        private

        def set_subscriber
          uuid = params[:job_digest_subscriber_id]
          @subscriber = JobDigestSubscriber.find_by!(uuid: uuid)
        end

        def initialize_subscriber(email, user_id)
          if user_id && (current_user.admin? || user_id.to_s == current_user.id.to_s)
            return JobDigestSubscriber.find_or_initialize_by(user_id: user_id)
          end

          if email && email == current_user.email
            return JobDigestSubscriber.find_or_initialize_by(user_id: current_user.id)
          end

          if email
            return JobDigestSubscriber.find_or_initialize_by(email: email)
          end

          JobDigestSubscriber.new
        end
      end
    end
  end
end
