# frozen_string_literal: true
module Api
  module V1
    module Users
      class FrilansFinansController < BaseController
        after_action :verify_authorized, except: %i(create)

        before_action :set_user

        resource_description do
          short 'API for Frilans Finans users'
          name 'Frilans Finans'
          description ''
          formats [:json]
          api_versions '1.0'
        end

        api :POST, '/users/:user_id/frilans-finans', 'Create new Frilans Finans user'
        description 'Creates and returns a new Frilans Finans user.'
        error code: 400, desc: 'Bad request'
        error code: 422, desc: 'Unprocessable entity'
        param :data, Hash, desc: 'Top level key', required: true do
          param :attributes, Hash, desc: 'Frilans Finans User attributes', required: true do # rubocop:disable Metrics/LineLength
            param :'account-clearing-nr', String, desc: 'User account clearing number'
            param :'account-nr', String, desc: 'User account number'
          end
        end
        example '{}'
        def create
          authorize_create(@user)

          if @user.frilans_finans_id.nil?
            document = FrilansFinansApi::User.create(attributes: user_params)
            @user.frilans_finans_id = document.resource.id if frilans_finans_active?
            @user.save!

            render json: {}, status: :ok
          else
            message = I18n.t('errors.user.frilans_finans_id')
            response_json = {
              errors: [{ status: 422, detail: message }]
            }
            render json: response_json, status: :unprocessable_entity
          end
        end

        private

        def set_user
          @user = User.find(params[:user_id])
        end

        def user_params
          attributes = FrilansFinans::UserWrapper.attributes(@user)

          whitelist = [:account_clearing_nr, :account_nr]
          jsonapi_params.permit(*whitelist).merge(attributes)
        end

        def authorize_create(user)
          raise Pundit::NotAuthorizedError unless policy(user).frilans_finans?
        end

        def frilans_finans_active?
          Rails.configuration.x.frilans_finans
        end
      end
    end
  end
end
