# frozen_string_literal: true
require 'rails_helper'

# Even though this describes SkillsController, it should really be BaseController tests
RSpec.describe Api::V1::SkillsController, type: :controller do
  context 'locale' do
    after(:each) do
      I18n.locale = I18n.default_locale
    end

    it 'sets the locale from header' do
      request.headers['X-API-LOCALE'] = 'sv'
      get :index, {}, {}
      expect(I18n.locale).to eq(:sv)
    end
  end

  context 'promo code' do
    before(:each) do
      Rails.configuration.x.promo_code = 'test_promo_code'
    end

    after(:each) do
      Rails.configuration.x.promo_code = nil
    end

    it 'lets the request pass if correct promo code' do
      request.headers['X-API-PROMO-CODE'] = 'test_promo_code'
      get :index, {}, {}
      expect(response.status).to eq(200)
    end

    it 'lets the request pass if the user is logged in' do
      user = FactoryGirl.create(:user)
      allow_any_instance_of(described_class).
        to(receive(:current_user).
        and_return(user))

      get :index, {}, {}
      expect(response.status).to eq(200)
    end

    context 'incorrect promo code' do
      it 'returns unauthorized status' do
        request.headers['X-API-PROMO-CODE'] = 'wrong_promo_code'
        get :index, {}, {}
        expect(response.status).to eq(401)
      end

      it 'returns JSONAPI errors' do
        request.headers['X-API-PROMO-CODE'] = 'wrong_promo_code'
        get :index, {}, {}
        jsonapi_error = JSON.parse(response.body)
        expected = {
          'errors' => [{
            'status' => 401,
            'code' => 'promo_code_or_login_required',
            'detail' => I18n.t('promo_code_required')
          }]
        }
        expect(jsonapi_error).to eq(expected)
      end
    end
  end

  context 'record not found' do
    let(:non_existing_record) { 123_456_768 }

    it 'returns JSONAPI errors' do
      get :show, { id: non_existing_record }, {}
      jsonapi_error = JSON.parse(response.body)
      expected = {
        'errors' => [{
          'status' => 404,
          'code' => 'not_found',
          'detail' => I18n.t('record_not_found')
        }]
      }
      expect(jsonapi_error).to eq(expected)
    end
  end
end
