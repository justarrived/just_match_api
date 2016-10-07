# frozen_string_literal: true
module Api
  module V1
    class BaseController < ::Api::BaseController
      resource_description do
        api_version '1.0'
        app_info <<-DOCDESCRIPTION
          # JustMatch API - v1.0 (beta) <a href="http://jsonapi.org/"><svg xmlns="http://www.w3.org/2000/svg" style="font-weight:normal;" width="90" height="20"><linearGradient id="b" x2="0" y2="100%"><stop offset="0" stop-color="#bbb" stop-opacity=".1"/><stop offset="1" stop-opacity=".1"/></linearGradient><mask id="a"><rect width="90" height="20" rx="3" fill="#fff"/></mask><g mask="url(#a)"><path fill="#555" d="M0 0h63v20H0z"/><path fill="#9f9f9f" d="M63 0h27v20H63z"/><path fill="url(#b)" d="M0 0h90v20H0z"/></g><g fill="#fff" text-anchor="middle" font-family="DejaVu Sans,Verdana,Geneva,sans-serif" font-size="11"><text x="31.5" y="15" fill="#010101" fill-opacity=".3">JSON API</text><text x="31.5" y="14">JSON API</text><text x="75.5" y="15" fill="#010101" fill-opacity=".3">1.0</text><text x="75.5" y="14">1.0</text></g></svg></a>

          ---

          The API follows the [JSON API 1.0](http://jsonapi.org) specification.

          ---

          ### Headers

          __Locale__

          `X-API-LOCALE: en` is used to specify current locale, valid locales are #{I18n.available_locales.map { |locale| "`#{locale}`" }.join(', ')}

          __Authorization__

          `Authorization: Token token=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX`

          __Promo code (not always active)__

          `X-API-PROMO-CODE: promocode` is used to specify the promo code, logged in users and logged in attemps are exempt.

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

          ### Locale

          Set the locale

              #{Doxxer.curl_for(name: 'users', id: 1, locale: true, join_with: " \\
                     ")}

          ### Authentication

          Pass the authorization token as a HTTP header

              #{Doxxer.curl_for(name: 'users', id: 1, auth: true, join_with: " \\
                     ")}
        DOCDESCRIPTION
        api_base_url '/api/v1'
      end

      ExpiredTokenError = Class.new(ArgumentError)

      before_action :authenticate_user_token!
      before_action :require_promo_code

      ALLOWED_INCLUDES = [].freeze

      # JSONAPI error codes
      TOKEN_EXPIRED_CODE = :token_expired

      # Needed for #authenticate_with_http_token
      include ActionController::HttpAuthentication::Token::ControllerMethods

      before_action :set_locale

      after_action :verify_authorized

      rescue_from Pundit::NotAuthorizedError, with: :user_forbidden
      rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
      rescue_from ExpiredTokenError, with: :expired_token

      def jsonapi_params
        @_deserialized_params ||= JsonApiDeserializer.parse(params)
      end

      def include_params
        @_include_params ||= JsonApiIncludeParams.new(params[:include])
      end

      def fields_params
        @_fields_params ||= JsonApiFieldsParams.new(params[:fields])
      end

      def included_resources
        @_included_resources ||= include_params.permit(self.class::ALLOWED_INCLUDES)
      end

      def included_resource?(resource_name)
        included_resources.include?(resource_name.to_s)
      end

      def require_promo_code
        return if logged_in?

        promo_code = Rails.configuration.x.promo_code
        return if promo_code.nil? || promo_code == {} # Rails config can return nil & {}
        return if promo_code == api_promo_code_header

        errors = JsonApiErrors.new
        status = 401 # unauthorized
        errors.add(status: 401, detail: I18n.t('invalid_credentials'))

        render json: errors, status: status
        false # Rails5: Should be updated to use throw
      end

      protected

      def api_render_errors(model)
        serialized_error = { errors: JsonApiErrorSerializer.serialize(model) }
        render json: serialized_error, status: :unprocessable_entity
      end

      def api_render(model_or_model_array, status: :ok, total: nil, meta: {})
        meta[:total] = total if total

        serialized_model = JsonApiSerializer.serialize(
          model_or_model_array,
          key_transform: key_transform_header,
          included: included_resources,
          fields: fields_params.to_h,
          current_user: current_user,
          meta: meta,
          request: request
        )

        render json: serialized_model, status: status
      end

      def record_not_found
        errors = JsonApiErrors.new
        errors.add(status: 404, detail: I18n.t('record_not_found'))

        render json: errors, status: :not_found
        false # Rails5: Should be updated to use throw
      end

      def require_user
        unless logged_in?
          errors = JsonApiErrors.new
          errors.add(status: 401, detail: I18n.t('not_logged_in_error'))

          render json: errors, status: :unauthorized
        end
        false # Rails5: Should be updated to use throw
      end

      def user_forbidden
        status = nil
        errors = JsonApiErrors.new

        if logged_in?
          status = 403 # forbidden
          errors.add(status: status, detail: I18n.t('invalid_credentials'))
        else
          status = 401 # unauthorized
          errors.add(status: 401, detail: I18n.t('not_logged_in_error'))
        end

        render json: errors, status: status
        false # Rails5: Should be updated to use throw
      end

      def expired_token
        errors = JsonApiErrors.new

        status = 401 # unauthorized
        errors.add(
          status: 401,
          detail: I18n.t('token_expired_error'),
          code: TOKEN_EXPIRED_CODE
        )

        render json: errors.to_json, status: status
        false # Rails5: Should be updated to use throw
      end

      def current_user
        @_current_user ||= User.new
      end

      def login_user(user)
        @_current_user = user
      end

      def not_logged_in?
        !logged_in?
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

      def api_promo_code_header
        request.headers['X-API-PROMO-CODE']
      end

      def key_transform_header
        case request.headers['X-API-KEY-TRANSFORM']
        when 'underscore' then :underscore
        else
          'dash'
        end
      end

      private

      def authenticate_user_token!
        authenticate_with_http_token do |auth_token, _options|
          token = Token.includes(:user).find_by(token: auth_token)
          return if token.nil?
          return raise ExpiredTokenError if token.expired?
          return @_current_user = token.user
        end
      end
    end
  end
end
