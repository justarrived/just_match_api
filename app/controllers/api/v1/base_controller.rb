# frozen_string_literal: true
module Api
  module V1
    class BaseController < ::Api::BaseController
      resource_description do
        api_version '1.0'
        # rubocop:disable Metrics/LineLength
        app_info "
          # JustMatch API - v1.0 (alpha) [![JSON API 1.0](https://img.shields.io/badge/JSON%20API-1.0-lightgrey.svg)](http://jsonapi.org/)

          ---

          The API follows the [JSON API 1.0](http://jsonapi.org) specification.

          ---

          ### Headers

          __Locale__

          `X-API-LOCALE: en` is used to specify current locale, valid locales are #{I18n.available_locales.map { |locale| "`#{locale}`" }.join(', ')}

          __Authorization__

          `Authorization: Token token=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX`

          ---

          ### Example job scenario

          Step | Request |
          ----------------------------------------------------------------------------------|:---------------------------------------------|
          1. User (owner) creates job                                                       | `POST /jobs/`                             |
          2. Another user can apply to a job by creating a job user                         | `POST /jobs/:job_id/users/`               |
          3. Owner can accept a user by updating job user `accepted`                        | `PATCH /jobs/:job_id/users/:job_user_id/` |
          4. User confirms that they will perform a job by updating job user `will-perform` | `PATCH /jobs/:job_id/users/:job_user_id/` |
          5. Owner creates invoice                                                          | `POST /jobs/:job_id/invoices`             |

          ---

          ### Examples

          __Jobs__

          Get a list of available jobs

              #{Doxxer.curl_for(name: 'jobs')}

          Get a single job

              #{Doxxer.curl_for(name: 'jobs', id: 1)}

          __Skills__

          Get a list of skills

              #{Doxxer.curl_for(name: 'skills')}

          Get a single skill

              #{Doxxer.curl_for(name: 'skills', id: 1)}

          ### Authentication

          Pass the authorization token as a HTTP header

              #{Doxxer.curl_for(name: 'users', id: 1, with_auth: true, join_with: " \\
                     ")}
        "
        # rubocop:enable Metrics/LineLength
        api_base_url '/api/v1'
      end

      ALLOWED_INCLUDES = [].freeze

      # Needed for #authenticate_with_http_token
      include ActionController::HttpAuthentication::Token::ControllerMethods

      before_action :set_locale

      after_action :verify_authorized

      rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

      def jsonapi_params
        @_deserialized_params ||= JsonApiDeserializer.parse(params)
      end

      def include_params
        @_include_params ||= IncludeParams.new(params[:include])
      end

      def fields_params
        @_fields_params ||= FieldsParams.new(params[:fields])
      end

      def included_resources
        @_included_resources ||= include_params.permit(self.class::ALLOWED_INCLUDES)
      end

      protected

      def respond_with_errors(model)
        serialized_error = { errors: ErrorSerializer.serialize(model) }
        render json: serialized_error, status: :unprocessable_entity
      end

      def api_render(model_or_model_array, status: :ok, total: nil)
        meta = {}
        meta[:total] = total if total

        serialized_model = JsonApiSerializer.serialize(
          model_or_model_array,
          included: included_resources,
          current_user: current_user,
          meta: meta
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

      def set_locale
        locale_header = api_locale_header
        if locale_header.nil?
          I18n.locale = current_user.locale
          return
        end

        # Only allow available locales
        I18n.available_locales.map(&:to_s).each do |locale|
          I18n.locale = locale if locale == locale_header
        end
      end

      def api_locale_header
        request.headers['X-API-LOCALE']
      end

      private

      def authenticate_user_token!
        authenticate_with_http_token do |token, _options|
          return User.includes(:language).find_by(auth_token: token)
        end
      end
    end
  end
end
