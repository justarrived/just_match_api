module Api
  class BaseController < ::ApplicationController
    # Needed for #authenticate_with_http_token
    include ActionController::HttpAuthentication::Token::ControllerMethods

    protected

    def require_user
      unless logged_in?
        error_message = I18n.t('not_logged_in_error')
        render json: { error: error_message }, status: :unauthorized
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
      authenticate_with_http_token do |token, _options|
        return User.find_by(auth_token: token)
      end
    end
  end
end
