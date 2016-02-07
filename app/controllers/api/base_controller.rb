module Api
  class BaseController < ::ApplicationController
    include Pundit
    # Needed for #authenticate_with_http_token
    include ActionController::HttpAuthentication::Token::ControllerMethods

    after_action :verify_authorized

    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    protected

    def user_not_authorized
      render json: { error: I18n.t('invalid_credentials') }, status: :unauthorized
      false
    end

    def require_user
      unless logged_in?
        error_message = I18n.t('not_logged_in_error')
        render json: { error: error_message }, status: :unauthorized
      end
      false
    end

    def current_user
      @_current_user ||= authenticate_user_token! || User.new
    end

    def logged_in?
      current_user.persisted?
    end

    def jsonapi_params
      @_deserialized_params ||= JsonApiDeserializer.parse(params)
    end

    def include_params
      @_include_params ||= IncludeParams.new(params[:include])
    end

    def fields_params
      @_fields_params ||= FieldsParams.new(params[:fields])
    end

    private

    def authenticate_user_token!
      authenticate_with_http_token do |token, _options|
        return User.find_by(auth_token: token)
      end
    end
  end
end
