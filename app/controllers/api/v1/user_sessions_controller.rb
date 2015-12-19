module Api
  module V1
    class UserSessionsController < BaseController
      def token
        email = params[:email]
        password = params[:password]

        user = User.find_by_credentials(email: email, password: password)

        if user
          render json: { token: user.auth_token }, status: :ok
        else
          render json: { error: 'Incorrect credentials' }, status: :forbidden
        end
      end
    end
  end
end
