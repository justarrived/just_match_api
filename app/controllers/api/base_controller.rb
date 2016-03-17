# frozen_string_literal: true
module Api
  class BaseController < ::ApiController
    include Pundit
    # Needed for #authenticate_with_http_token
    include ActionController::HttpAuthentication::Token::ControllerMethods

    after_action :verify_authorized

    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    protected

    def respond_with_errors(model)
      serialized_error = { errors: ErrorSerializer.serialize(model) }
      render json: serialized_error, status: :unprocessable_entity
    end

    def api_render(model_or_model_array, included: [], status: :ok)
      serialized_model = JsonApiSerializer.serialize(
        model_or_model_array,
        included: included
      )

      render json: serialized_model, status: status
    end

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

    def login_user(user)
      @_current_user = user
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
