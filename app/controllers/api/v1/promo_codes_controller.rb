# frozen_string_literal: true
module Api
  module V1
    class PromoCodesController < BaseController
      before_action :require_promo_code, except: [:validate]

      after_action :verify_authorized, only: []

      api :POST, '/promo-codes/validate/', 'Validate promo code'
      description 'Returns 200 ok status if valid otherwise unprocessable entity.'
      error code: 422, desc: 'Unprocessable entity'
      param :data, Hash, desc: 'Top level key', required: true do
        param :attributes, Hash, desc: 'Promo codes attributes', required: true do
          param :'promo-code', String, desc: 'Promo code', required: true
        end
      end
      def validate
        promo_code = Rails.configuration.x.promo_code
        if promo_code.nil?
          render json: {}, status: :ok
          return
        end

        if promo_code == jsonapi_params[:promo_code]
          render json: {}, status: :ok
        else
          errors = [{
            status: 422,
            source: { pointer: '/data/attributes/promo-code' },
            detail: I18n.t('errors.messages.invalid')
          }]

          render json: { errors: errors }, status: :unprocessable_entity
        end
      end
    end
  end
end
