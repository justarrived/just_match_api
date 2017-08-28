# frozen_string_literal: true

module Api
  module V1
    module Jobs
      class DigestSubscribersController < BaseController
        after_action :verify_authorized, except: %i(show create destroy)

        before_action :set_subscriber, only: %i(show destroy)

        resource_description do
          api_versions '1.0'
          name 'Job digest subscriber'
          short 'API for digest subscribers'
          description ''
          formats [:json]
        end

        api :GET, '/digests/subscribers/:digest_subscriber_uuid_or_user_id', 'Show digest subscriber' # rubocop:disable Metrics/LineLength
        description 'Show digest subscriber.'
        ApipieDocHelper.params(self)
        example Doxxer.read_example(DigestSubscriber)
        def show
          api_render(@subscriber)
        end

        api :POST, '/digests/subscribers/', 'Create digest subscriber'
        description 'Create digest subscriber.'
        error code: 400, desc: 'Bad request'
        error code: 422, desc: 'Unprocessable entity'
        ApipieDocHelper.params(self)
        param :data, Hash, desc: 'Top level key', required: true do
          param :attributes, Hash, desc: 'JobDigestSubscriber attributes', required: true do # rubocop:disable Metrics/LineLength
            param :user_id, String, desc: 'User id (required if email is blank)'
            param :email, String, desc: 'Email (required if email is blank)'
          end
        end
        def create
          subscriber = CreateDigestSubscriberService.call(
            current_user: current_user,
            user_id: jsonapi_params[:user_id].presence,
            email: jsonapi_params[:email].presence
          )

          if subscriber.persisted?
            api_render(subscriber, status: :created)
          else
            api_render_errors(subscriber)
          end
        end

        api :DELETE, '/digests/subscribers/:digest_subscriber_uuid_or_user_id', 'Delete job digest' # rubocop:disable Metrics/LineLength
        description 'Delete digest subscriber.'
        error code: 400, desc: 'Bad request'
        error code: 404, desc: 'Not found'
        ApipieDocHelper.params(self)
        def destroy
          uuid = params[:digest_subscriber_id]
          digest_subscriber = DigestSubscriber.find_by!(uuid: uuid)
          digest_subscriber.destroy!

          head :no_content
        end

        private

        def set_subscriber
          @subscriber = Queries::FindDigestSubscriber.from_uuid_or_user_id(
            current_user: current_user,
            uuid_or_user_id: params[:digest_subscriber_id]
          )
        end
      end
    end
  end
end
