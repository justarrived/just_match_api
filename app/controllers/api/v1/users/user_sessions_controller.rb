# frozen_string_literal: true
module Api
  module V1
    module Users
      class UserSessionsController < BaseController
        after_action :verify_authorized, only: []

        resource_description do
          short 'API for managing user sessions'
          name 'User sessions'
          description ''
          formats [:json]
          api_versions '1.0'
        end

        before_action :require_promo_code, except: [:create]

        api :POST, '/users/sessions/', 'Get auth token'
        description 'Returns the Users auth token if the user is allowed.'
        error code: 401, desc: 'Unauthorized'
        error code: 403, desc: 'Forbidden'
        param :data, Hash, desc: 'Top level key', required: true do
          param :attributes, Hash, desc: 'User session attributes', required: true do
            param :email, String, desc: 'Email', required: true
            param :password, String, desc: 'Password', required: true
          end
        end
        example '# Response example
  {
    "data": {
      "id": "XYZ",
      "type": "token",
      "attributes": {
        "auth-token": "XYZ",
        "user-id": "1"
      }
    }
  }'
        def create
          email = jsonapi_params[:email]
          password = jsonapi_params[:password]

          user = User.find_by_credentials(email: email, password: password)

          if user
            return respond_with_banned if user.banned

            response = wrap_token_response(user_id: user.id, token: user.auth_token)
            render json: response, status: :created
          else
            respond_with_login_failure
          end
        end

        api :DELETE, '/users/sessions/:auth_token', 'Reset auth token'
        description 'Resets the Users auth token if the user is allowed.'
        error code: 404, desc: 'Not found'
        error code: 422, desc: 'Unprocessable entity'
        def destroy
          token = params[:id]

          user = User.find_by(auth_token: token)
          if user
            user.auth_token = user.generate_auth_token
            user.save!

            head :no_content
          else
            render json: {}, status: :not_found
          end
        end

        private

        def respond_with_banned
          errors = JsonApiErrors.new
          errors.add(status: 403, detail: I18n.t('errors.user_session.banned'))

          render json: errors, status: :forbidden
        end

        def respond_with_login_failure
          message = I18n.t('errors.user_session.wrong_email_or_password')
          errors = JsonApiErrors.new
          errors.add(status: 422, detail: message, pointer: :email)
          errors.add(status: 422, detail: message, pointer: :password)

          render json: errors, status: :unprocessable_entity
        end

        def wrap_token_response(user_id:, token:)
          {
            data: {
              id: token,
              type: :token,
              attributes: {
                'auth-token' => token,
                'user-id' => user_id.to_s
              }
            }
          }
        end
      end
    end
  end
end
