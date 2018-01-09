# frozen_string_literal: true

module Api
  module V1
    module Users
      class UtalkCodesController < BaseController
        before_action :require_user
        before_action :set_user
        before_action :set_utalk_code, only: %i[index]

        after_action :verify_authorized, except: %i[index]

        resource_description do
          resource_id 'utalk_codes'
          short 'API for managing Utalk codes'
          name 'Utalk codes'
          description 'Codes for Utalk'
          formats [:json]
          api_versions '1.0'
        end

        ALLOWED_INCLUDES = %w().freeze

        api :GET, '/users/:user_id/utalk-codes/', 'Show Utalk code for user'
        description 'Returns utalk code if the user is allowed.'
        error code: 401, desc: 'Not authorized'
        error code: 403, desc: 'Forbidden'
        error code: 404, desc: 'Not found'
        ApipieDocHelper.params(self)
        example Doxxer.read_example(UtalkCode)
        def index
          unless @utalk_code
            render json: { data: nil }
            return
          end

          if current_user != @user && !current_user.admin?
            render_user_forbidden
            return
          end

          api_render(@utalk_code)
        end

        api :POST, '/users/:user_id/utalk-codes/', 'Create new user skill'
        description 'Creates and returns new user skill if the user is allowed.'
        error code: 400, desc: 'Bad request'
        error code: 401, desc: 'Unauthorized'
        error code: 404, desc: 'Not found'
        error code: 422, desc: 'Unprocessable entity'
        ApipieDocHelper.params(self)
        example '{}'
        def create
          authorize(UtalkCode)

          @utalk_code = ClaimUtalkCodeService.call(user: @user)

          if @utalk_code.save
            api_render(@utalk_code, status: :created)
          else
            api_render_errors(@utalk_code)
          end
        rescue ClaimUtalkCodeService::NoUnClaimedUtalkCodeError
          errors = JsonApiErrors.new
          errors.add(status: 501, detail: I18n.t('errors.utalk_code.no_unclaimed'))

          render json: errors, status: :not_implemented
        end

        private

        def set_user
          @user = User.find(params[:user_id])
        end

        def set_utalk_code
          @utalk_code = @user&.utalk_code
        end
      end
    end
  end
end
