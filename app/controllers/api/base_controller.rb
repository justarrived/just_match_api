module Api
  class BaseController < ::ApplicationController
    # Needed for #authenticate_with_http_token
    include ActionController::HttpAuthentication::Token::ControllerMethods

    protected

    def current_user
      @_current_user ||= authenticate_user_token! || User.new
    end

    private

    def authenticate_user_token!
      authenticate_with_http_token do |token, options|
        return User.find_by(auth_token: token)
      end
    end
  end
end
