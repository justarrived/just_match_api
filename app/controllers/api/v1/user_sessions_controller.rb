# frozen_string_literal: true
module Api
  module V1
    class UserSessionsController < BaseController
      after_action :verify_authorized, only: []

      resource_description do
        short 'API for managing user sessions'
        name 'User sessions'
        description ''
        formats [:json]
        api_versions '1.0'
      end

      api :POST, '/user_sessions/', 'Get auth token'
      description 'Returns the Users auth token if the user is allowed.'
      error code: 401, desc: 'Unauthorized'
      param :data, Hash, desc: 'Top level key', required: true do
        param :attributes, Hash, desc: 'User session attributes', required: true do
          param :email, String, desc: 'Email', required: true
          param :password, String, desc: 'Password', required: true
        end
      end
      example '# Example response JSON
{
  "data": {
    "id": "XYZ",
    "type": "token",
    "attributes": {
      "auth_token": "XYZ"
    }
  }
}'
      def create
        email = jsonapi_params[:email]
        password = jsonapi_params[:password]

        user = User.find_by_credentials(email: email, password: password)

        if user
          response = wrap_token_response(token: user.auth_token)
          render json: response, status: :created
        else
          error_message = I18n.t('invalid_credentials')
          render json: { error: error_message }, status: :unauthorized
        end
      end

      api :DELETE, '/user_sessions/:auth_token', 'Reset auth token'
      description 'Resets the Users auth token if the user is allowed.'
      error code: 422, desc: 'Unprocessable entity'
      def destroy
        token = params[:id]

        user = User.find_by(auth_token: token)
        if user
          user.auth_token = user.generate_auth_token!
          head :no_content
        else
          error_message = I18n.t('no_such_token')
          render json: { error: error_message }, status: :unprocessable_entity
        end
      end

      private

      def wrap_token_response(token:)
        {
          data: {
            id: token,
            type: :token,
            attributes: {
              auth_token: token
            }
          }
        }
      end
    end
  end
end
