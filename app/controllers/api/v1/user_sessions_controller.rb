module Api
  module V1
    class UserSessionsController < BaseController
      api :POST, '/user_sessions/', 'Get auth token'
      description 'Returns the Users auth token if the user is allowed to.'
      formats ['json']
      param :email, String, desc: 'Email', required: true
      param :password, String, desc: 'Password', required: true
      example '{ "token": "..." }'
      def create
        email = params[:email]
        password = params[:password]

        user = User.find_by_credentials(email: email, password: password)

        if user
          render json: { token: user.auth_token }, status: :ok
        else
          error_message = I18n.t('invalid_credentials')
          render json: { error: error_message }, status: :forbidden
        end
      end

      api :DELETE, '/user_sessions/', 'Reset auth token'
      description 'Resets the Users auth token if the user is allowed to.'
      formats ['json']
      param :id, String, desc: 'Auth token', required: true
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
    end
  end
end
