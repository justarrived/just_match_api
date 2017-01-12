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

        # rubocop:disable Metrics/LineLength
        api :POST, '/users/:user_id/frilans-finans', '[DEPRECATED] Adds bank account details to Frilans Finans user'
        description '
          DEPRECATED please set bank account details directly on user instead `PATCH /api/v1/users/`.

          Creates and returns a new Frilans Finans user.

          __Note__: Account clearning number and account number needs to be present __or__ IBAN and BIC
        '
        # rubocop:enable Metrics/LineLength
        error code: 400, desc: 'Bad request'
        error code: 422, desc: 'Unprocessable entity'
        param :data, Hash, desc: 'Top level key', required: true do
          param :attributes, Hash, desc: 'Frilans Finans payment details', required: true do # rubocop:disable Metrics/LineLength
            param :account_clearing_number, String, desc: 'User account clearing number'
            param :account_number, String, desc: 'User account number'
            param :iban, String, desc: 'IBAN number'
            param :bic, String, desc: 'BIC number'
          end
        end
        example <<-JSON
# Response example
{}
# Error response example
{
  "errors": [
    {
      "status": 422,
      "detail": "can't be blank",
      "source": {
        "pointer": "/data/attributes/account_number"
      }
    },
    {
      "status": 422,
      "detail": "is too short",
      "source": {
        "pointer": "/data/attributes/account_number"
      }
    },
    {
      "status": 422,
      "detail": "invalid characters",
      "source": {
        "pointer": "/data/attributes/account_number"
      }
    },
    {
      "status": 422,
      "detail": "unknown clearing number",
      "source": {
        "pointer": "/data/attributes/account_clearing_number"
      }
    }
  ]
}
        JSON
        def create
          ActiveSupport::Deprecation.warn('POST /users/:user_id/frilans-finans has been deprecated, please set User#account_number and User#account_clearing_number instead.') # rubocop:disable Metrics/LineLength

          authorize_create(@user)

          errors = ff_param_errors
          if errors.any?
            render json: errors, status: :unprocessable_entity
            return
          end

          unless frilans_finans_active?
            render json: {}, status: :ok
            return
          end

          if @user.frilans_finans_id.nil?
            complete_params = user_params.merge(ff_user_params)
            document = FrilansFinansApi::User.create(attributes: complete_params)
            @user.frilans_finans_id = document.resource.id
          else
            id = @user.frilans_finans_id!
            # On update Frilans Finans don't want the attribute to be nested under a
            # user key (unlike create)
            FrilansFinansApi::User.update(id: id, attributes: ff_user_params)
          end

          @user.tap do |user|
            user.account_clearing_number = jsonapi_params[:account_clearing_number]
            user.account_number = jsonapi_params[:account_number]

            user.frilans_finans_payment_details = true
            user.save!
          end

          render json: {}, status: :ok
        end

        private

        def set_user
          @user = User.find(params[:user_id])
        end

        def user_params
          FrilansFinans::UserWrapper.attributes(@user)
        end

        def ff_user_params
          jsonapi_params.permit(:account_clearing_number, :account_number, :iban, :bic)
        end

        def authorize_create(user)
          raise Pundit::NotAuthorizedError unless policy(user).frilans_finans?
        end

        def ff_param_errors
          errors = validate_non_blank(ff_user_params, :iban, :bic)

          # If one of the two foreign bank fields are filled out return, otherwise we'll
          # assume that the user is gonna add local bank details.
          #
          # The drawback is if no fields at all are submitted only the Swedish
          # bank fields will be returned as blank validation errors
          return foreign_bank_account_errors(errors) if errors.length != 2

          errors = validate_non_blank(
            ff_user_params,
            :account_clearing_number,
            :account_number
          )

          swedish_bank_account_errors(errors)
        end

        def foreign_bank_account_errors(errors)
          # Validate IBAN
          iban_tool = IBANAccount.new(ff_user_params[:iban])
          iban_tool.errors.each do |error|
            message = I18n.t("errors.bank_account.iban.#{error}")
            errors.add(attribute: :iban, detail: message)
          end

          # Validate BIC
          bic_tool = BICTool.new(ff_user_params[:bic])
          bic_tool.errors.each do |error|
            message = I18n.t("errors.bank_account.bic.#{error}")
            errors.add(attribute: :bic, detail: message)
          end
          errors
        end

        def swedish_bank_account_errors(errors)
          full_account = [
            ff_user_params[:account_clearing_number],
            ff_user_params[:account_number]
          ].join

          field_map = {
            clearing_number: :account_clearing_number,
            serial_number: :account_number,
            account: :account
          }
          SwedishBankAccount.new(full_account).tap do |account|
            account.errors_by_field do |field, error_types|
              error_types.each do |type|
                message = I18n.t("errors.bank_account.#{type}")
                errors.add(attribute: field_map[field], detail: message)
              end
            end
          end

          errors
        end

        def frilans_finans_active?
          Rails.configuration.x.frilans_finans
        end

        def validate_non_blank(params_hash, *fields)
          message = I18n.t('errors.messages.blank')
          errors = JsonApiErrors.new
          fields.map do |field|
            errors.add(detail: message, attribute: field) if params_hash[field].blank?
          end
          errors
        end
      end
    end
  end
end
