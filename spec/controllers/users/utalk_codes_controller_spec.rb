# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Users::UtalkCodesController, type: :controller do
  describe 'GET #index' do
    it 'returns utalk code for user' do
      user = FactoryBot.create(:user_with_tokens)
      FactoryBot.create(:utalk_code, user: user)

      get :index, params: { user_id: user.id, auth_token: user.auth_token }

      expect(response.status).to eq(200)
    end

    context 'tries to fetch another users Utalk code' do
      it 'returns forbidden status' do
        current_user = FactoryBot.create(:user_with_tokens)

        user = FactoryBot.create(:user)
        utalk_code = FactoryBot.create(:utalk_code, user: user)

        get :index, params: { user_id: user.id, auth_token: current_user.auth_token }

        utalk_code.reload

        expect(response.status).to eq(403)
      end
    end

    context 'with no attached utalk_code' do
      it 'returns not found' do
        user = FactoryBot.create(:user_with_tokens)

        get :index, params: { user_id: user.id, auth_token: user.auth_token }

        expect(response.status).to eq(404)
      end
    end
  end

  describe 'POST #create' do
    context 'with no available utalk code' do
      it 'returns server error' do
        user = FactoryBot.create(:user_with_tokens)
        FactoryBot.create(:utalk_code, user: FactoryBot.create(:user))

        post :create, params: { user_id: user.id, auth_token: user.auth_token }

        data = JSON.parse(response.body)

        expect(response.status).to eq(501)
        expect(data['errors'].first['status']).to eq(501)
      end
    end

    context 'with no utalk code previously attached' do
      it 'returns created status and has attached a utalk code with user' do
        user = FactoryBot.create(:user_with_tokens)
        utalk_code = FactoryBot.create(:unclaimed_utalk_code)

        post :create, params: { user_id: user.id, auth_token: user.auth_token }

        user.reload

        expect(response.status).to eq(201)
        expect(user.utalk_code).to eq(utalk_code)
      end
    end

    context 'with utalk code previously attached' do
      it 'returns created status and has attached a utalk code with user' do
        user = FactoryBot.create(:user_with_tokens)
        utalk_code = FactoryBot.create(:utalk_code, user: user)

        post :create, params: { user_id: user.id, auth_token: user.auth_token }

        user.reload

        expect(response.status).to eq(201)
        expect(user.utalk_code).to eq(utalk_code)
      end
    end
  end
end
