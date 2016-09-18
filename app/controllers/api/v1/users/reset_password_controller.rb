# frozen_string_literal: true
module Api
  module V1
    module Users
      class ResetPasswordController < BaseController
        before_action :require_promo_code, except: [:create]
        after_action :verify_authorized, only: []

        api :POST, '/users/reset-password/', 'Reset password'
        description 'Sends a reset password email to user.'
        error code: 422, desc: 'Unprocessable entity'
        param :data, Hash, desc: 'Top level key', required: true do
          param :attributes, Hash, desc: 'Reset password attributes', required: true do
            param :email, String, desc: 'Email', required: true
          end
        end
        example '# Response example
{}
'
        def create
          user = User.find_by(email: jsonapi_params[:email])

          CreateUserResetPasswordService.call(user: user) if user

          # Always render 202 accepted status, we don't want to increase the number of
          # places that exposes what emails are in the system
          render json: {}, status: :accepted
        end
      end
    end
  end
end
