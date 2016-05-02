# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::PromoCodesController, type: :controller do
  context 'active promo code' do
    before(:each) do
      Rails.configuration.x.promo_code = 'test_promo_code'
    end

    after(:each) do
      Rails.configuration.x.promo_code = nil
    end

    let(:valid_params) do
      {
        data: {
          attributes: {
            promo_code: 'test_promo_code'
          }
        }
      }
    end

    context 'valid attributes' do
      it 'returns 200 ok' do
        post :validate, valid_params, {}
        expect(response.status).to eq(200)
      end
    end

    context 'invalid attributes' do
      it 'returns 422 unprocessable entity' do
        post :validate, {}, {}
        expect(response.status).to eq(422)
      end
    end
  end

  context 'inactive promo code' do
    it 'returns 200 ok status' do
      post :validate, {}, {}
      expect(response.status).to eq(200)
    end
  end
end
