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
        to(receive(:authenticate_user_token!).
        and_return(user))

      get :index, {}, {}
      expect(response.status).to eq(200)
    end

    it 'returns unauthorized status if incorrect promo code' do
      request.headers['X-API-PROMO-CODE'] = 'wrong_promo_code'
      get :index, {}, {}
      expect(response.status).to eq(401)
    end
  end
end
