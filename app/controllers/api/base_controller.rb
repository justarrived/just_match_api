module Api
  class BaseController < ::ApplicationController
    # Needed for #authenticate_with_http_token
    include ActionController::HttpAuthentication::Token::ControllerMethods

    protected

    def require_user
      unless logged_in?
        render json: { error: 'Must be logged in.' }, status: :unauthorized
      end
    end

    def current_user
      @_current_user ||= authenticate_user_token! || User.new
    end

    def logged_in?
      current_user.persisted?
    end

    private

    def authenticate_user_token!
      # FIXME: Check how to pass HTTP header values in Rails controller tests
      #        then remove this env check!
      if Rails.env.test?
        User.find_by(auth_token: session[:token])
      else
        authenticate_with_http_token do |token, _options|
          return User.find_by(auth_token: token)
        end
      end
    end
  end
end
