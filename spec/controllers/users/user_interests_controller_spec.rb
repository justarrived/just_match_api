# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Users::UserInterestsController, type: :controller do
  let(:valid_attributes) do
    {}
  end

  let(:invalid_attributes) do
    {}
  end

  describe 'GET #index' do
    it 'assigns all user interests as @interests' do
      user = FactoryGirl.create(:user_with_interests, interests_count: 2)
      user.create_auth_token
      user.user_interests.first.update(level: 3)
      user.user_interests.last.interest.update(internal: true)

      user_interest = user.user_interests.first
      get :index, params: { auth_token: user.auth_token, user_id: user.to_param }
      expect(assigns(:user_interests)).to eq([user_interest])
    end

    it 'does not return internal interests' do
      user = FactoryGirl.create(:user_with_interests, interests_count: 1)
      user.create_auth_token
      user.user_interests.first.interest.update(internal: true)

      get :index, params: { auth_token: user.auth_token, user_id: user.to_param }
      expect(assigns(:user_interests)).to eq([])
    end

    it 'returns 200 ok status' do
      user = FactoryGirl.create(:user_with_tokens)
      get :index, params: { auth_token: user.auth_token, user_id: user.to_param }
      expect(response.status).to eq(200)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested user interest as @interest, @user_interest, @user' do
      user = FactoryGirl.create(:user_with_interests, interests_count: 1)
      user_interest = user.user_interests.first
      interest = user_interest.interest
      params = {
        auth_token: user.auth_token,
        user_id: user.to_param,
        user_interest_id: user_interest.to_param
      }
      get :show, params: params

      expect(assigns(:interest)).to eq(interest)
      expect(assigns(:user_interest)).to eq(user_interest)
      expect(assigns(:user)).to eq(user)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      context 'authorized user' do
        let(:user) { FactoryGirl.create(:user_with_tokens) }

        it 'creates a new UserInterest' do
          interest = FactoryGirl.create(:interest)
          params = {
            auth_token: user.auth_token,
            user_id: user.to_param,
            data: {
              attributes: { id: interest.to_param }
            }
          }
          expect do
            post :create, params: params
          end.to change(UserInterest, :count).by(1)
        end

        it 'assigns a newly created user_interest as @user_interest' do
          interest = FactoryGirl.create(:interest)
          params = {
            auth_token: user.auth_token,
            user_id: user.to_param,
            data: {
              attributes: { id: interest.to_param, level: 5 }
            }
          }
          post :create, params: params
          expect(assigns(:user_interest)).to be_a(UserInterest)
          expect(assigns(:user_interest)).to be_persisted
          expect(assigns(:user_interest).level).to eq(5)
        end

        it 'returns created status' do
          interest = FactoryGirl.create(:interest)
          params = {
            auth_token: user.auth_token,
            user_id: user.to_param,
            data: {
              attributes: { id: interest.to_param }
            }
          }
          post :create, params: params
          expect(response.status).to eq(201)
        end
      end
    end

    context 'not authorized' do
      it 'returns not authorized status' do
        user = FactoryGirl.create(:user)
        params = {
          auth_token: 'wat',
          user_id: user.to_param, interest: {}
        }
        post :create, params: params
        expect(response.status).to eq(401)
      end
    end

    context 'with invalid params' do
      context 'authorized user' do
        let(:user) { FactoryGirl.create(:user_with_tokens) }

        it 'assigns a newly created but unsaved user_interest as @user_interest' do
          params = {
            auth_token: user.auth_token,
            user_id: user.to_param, interest: {}
          }
          post :create, params: params
          expect(assigns(:user_interest)).to be_a_new(UserInterest)
        end

        it 'returns unprocessable entity status' do
          params = {
            auth_token: user.auth_token,
            user_id: user.to_param, interest: {}
          }
          post :create, params: params
          expect(response.status).to eq(422)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'authorized user' do
      let(:user) do
        FactoryGirl.create(:user_with_interests).tap(&:create_auth_token)
      end

      it 'destroys the requested user_interest' do
        user_interest = user.user_interests.first
        params = {
          auth_token: user.auth_token,
          user_id: user.to_param,
          user_interest_id: user_interest.to_param
        }
        expect do
          delete :destroy, params: params
        end.to change(UserInterest, :count).by(-1)
      end

      it 'does *not* destroy the requested user_interest if touched by admin' do
        user_interest = user.user_interests.first
        user_interest.update(level_by_admin: 5)

        params = {
          auth_token: user.auth_token,
          user_id: user.to_param,
          user_interest_id: user_interest.to_param
        }
        expect do
          delete :destroy, params: params
        end.to change(UserInterest, :count).by(0)
      end

      it 'returns no content status' do
        user_interest = user.user_interests.first
        params = {
          auth_token: user.auth_token,
          user_id: user.to_param,
          user_interest_id: user_interest.to_param
        }
        delete :destroy, params: params
        expect(response.status).to eq(204)
      end
    end

    context 'user not allowed' do
      it 'does not destroy the requested user_interest' do
        user = FactoryGirl.create(:user_with_interests)
        user_interest = user.user_interests.first
        other_user = FactoryGirl.create(:user_with_tokens)
        expect do
          params = {
            auth_token: other_user.auth_token,
            user_id: user.to_param,
            user_interest_id: user_interest.to_param
          }
          delete :destroy, params: params
        end.to change(UserInterest, :count).by(0)
      end

      it 'returns not authorized status' do
        user = FactoryGirl.create(:user_with_interests)
        user_interest = user.user_interests.first
        other_user = FactoryGirl.create(:user_with_tokens)
        params = {
          auth_token: other_user.auth_token,
          user_id: user.to_param,
          user_interest_id: user_interest.to_param
        }
        delete :destroy, params: params
        expect(response.status).to eq(403)
      end
    end
  end
end
