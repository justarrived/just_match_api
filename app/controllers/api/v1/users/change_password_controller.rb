# frozen_string_literal: true
module Api
  module V1
    module Users
      class ChangePasswordController < BaseController
        after_action :verify_authorized, only: []

        before_action :require_promo_code, except: [:create]
        before_action :set_user

        NoSuchResetPasswordToken = Class.new(StandardError)
        rescue_from NoSuchResetPasswordToken, with: :respond_with_no_such_reset_token_error # rubocop:disable Metrics/LineLength

        # rubocop:disable Metrics/LineLength
        api :POST, '/users/change-password/', 'Change password'
        description 'Change password for user, use one time token if the user is not logged in'
        error code: 404, desc: 'Not found'
        error code: 422, desc: 'Unprocessable entity'
        param :data, Hash, desc: 'Top level key', required: true do
          param :attributes, Hash, desc: 'Reset password attributes', required: true do
            param :password, String, desc: 'New password', required: true
            param :old_password, String, desc: 'Old password (required if logged in)'
            param :one_time_token, String, desc: 'One time token (required if not logged in)'
          end
        end
        # rubocop:enable Metrics/LineLength
        example '# Response example
{}'
        def create
          new_password = jsonapi_params[:password]
          old_password = jsonapi_params[:old_password]

          # If the user logged in, require the old password,
          # otherwise the one_time_token is enough
          if logged_in? && User.wrong_password?(@user, old_password)
            return render json: wrong_password_error, status: :unprocessable_entity
          end

          if User.valid_password_format?(new_password)
            @user.generate_one_time_token
            @user.password = new_password
            @user.save!

            # Destroy all other user sessions
            @user.auth_tokens.destroy_all

            ChangedPasswordNotifier.call(user: @user)

            render json: {}
          else
            render json: json_api_password_error, status: :unprocessable_entity
          end
        end

        private

        def set_user
          @user = if logged_in?
                    current_user
                  else
                    token = jsonapi_params[:one_time_token]
                    token_user = User.find_by_one_time_token(token)
                    raise NoSuchResetPasswordToken if token_user.nil?
                    token_user
                  end
        end

        def wrong_password_error
          message = I18n.t('errors.user.wrong_password')
          errors = JsonApiErrors.new
          errors.add(detail: message, attribute: :old_password)
          errors
        end

        def respond_with_no_such_reset_token_error
          message = I18n.t('errors.user.no_such_reset_token_error')
          errors = JsonApiErrors.new
          errors.add(detail: message, attribute: :one_time_token)

          render json: errors, status: :unprocessable_entity
        end

        def json_api_password_error
          message = I18n.t(
            'errors.user.password_length',
            min_length: User::MIN_PASSWORD_LENGTH,
            max_length: User::MAX_PASSWORD_LENGTH
          )
          errors = JsonApiErrors.new
          errors.add(detail: message, attribute: :password)
          errors
        end
      end
    end
  end
end
