# frozen_string_literal: true

module Api
  module V1
    module Users
      class ResetPasswordController < BaseController
        after_action :verify_authorized, only: []

        RESET_TOKEN_VALID_DURATION = -> { 2.hours }

        api :POST, '/users/reset-password/', 'Reset password'
        description 'Sends a reset password email to user.'
        error code: 422, desc: 'Unprocessable entity'
        param :data, Hash, desc: 'Top level key', required: true do
          param :attributes, Hash, desc: 'Reset password attributes', required: true do
            param :email_or_phone, String, desc: 'Email or phone', required: true
          end
        end
        example '# Response example
{}
'
        def create
          user = User.find_by_email_or_phone(jsonapi_params[:email_or_phone])

          if user
            user.generate_one_time_token(valid_duration: RESET_TOKEN_VALID_DURATION.call)
            user.save!
            ResetPasswordNotifier.call(user: user)
          end

          # Always render 202 accepted status, we don't want to increase the number of
          # places that exposes what emails are in the system
          render json: {}, status: :accepted
        end
      end
    end
  end
end
