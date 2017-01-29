# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::Users::UserInterestsController, type: :controller do
  let(:valid_attributes) do
    {}
  end

  let(:invalid_attributes) do
    {}
  end

  let(:valid_session) do
    user = FactoryGirl.create(:user_with_tokens)
    allow_any_instance_of(described_class).
      to(receive(:current_user).
      and_return(user))
    { token: user.auth_token }
  end

  describe 'GET #index' do
    it 'assigns all user interests as @interests' do
      user = FactoryGirl.create(:user_with_interests, interests_count: 2)
      user.user_interests.last.interest.update(internal: true)

      allow_any_instance_of(described_class).
        to(receive(:current_user).
        and_return(user))

      user_interest = user.user_interests.first
      get :index, params: { user_id: user.to_param }
      expect(assigns(:user_interests)).to eq([user_interest])
    end

    it 'does not return internal interests' do
      user = FactoryGirl.create(:user_with_interests, interests_count: 1)
      user.user_interests.first.interest.update(internal: true)

      allow_any_instance_of(described_class).
        to(receive(:current_user).
        and_return(user))

      get :index, params: { user_id: user.to_param }
      expect(assigns(:user_interests)).to eq([])
    end

    it 'returns 200 ok status' do
      user = FactoryGirl.create(:user)
      allow_any_instance_of(described_class).
        to(receive(:current_user).
        and_return(user))
      get :index, params: { user_id: user.to_param }
      expect(response.status).to eq(200)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested user interest as @interest, @user_interest, @user' do
      user = FactoryGirl.create(:user_with_interests, interests_count: 1)
      user_interest = user.user_interests.first
      interest = user_interest.interest
      params = { user_id: user.to_param, user_interest_id: user_interest.to_param }
      get :show, params: params, headers: valid_session

      expect(assigns(:interest)).to eq(interest)
      expect(assigns(:user_interest)).to eq(user_interest)
      expect(assigns(:user)).to eq(user)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      context 'authorized user' do
        let(:user) { User.find_by_auth_token(valid_session[:token]) }

        it 'creates a new UserInterest' do
          interest = FactoryGirl.create(:interest)
          params = {
            user_id: user.to_param,
            data: {
              attributes: { id: interest.to_param }
            }
          }
          expect do
            post :create, params: params, headers: valid_session
          end.to change(UserInterest, :count).by(1)
        end

        it 'assigns a newly created user_interest as @user_interest' do
          interest = FactoryGirl.create(:interest)
          params = {
            user_id: user.to_param,
            data: {
              attributes: { id: interest.to_param, level: 7 }
            }
          }
          post :create, params: params, headers: valid_session
          expect(assigns(:user_interest)).to be_a(UserInterest)
          expect(assigns(:user_interest)).to be_persisted
          expect(assigns(:user_interest).level).to eq(7)
        end

        it 'returns created status' do
          interest = FactoryGirl.create(:interest)
          params = {
            user_id: user.to_param,
            data: {
              attributes: { id: interest.to_param }
            }
          }
          post :create, params: params, headers: valid_session
          expect(response.status).to eq(201)
        end
      end
    end

    context 'not authorized' do
      it 'returns not authorized status' do
        allow_any_instance_of(described_class).
          to(receive(:current_user).
          and_return(User.new))
        user = FactoryGirl.create(:user)
        post :create, params: { user_id: user.to_param, interest: {} }
        expect(response.status).to eq(401)
      end
    end

    context 'with invalid params' do
      context 'authorized user' do
        let(:user) { User.find_by_auth_token(valid_session[:token]) }

        it 'assigns a newly created but unsaved user_interest as @user_interest' do
          post :create, params: { user_id: user.to_param, interest: {} }, headers: valid_session # rubocop:disable Metrics/LineLength
          expect(assigns(:user_interest)).to be_a_new(UserInterest)
        end

        it 'returns unprocessable entity status' do
          post :create, params: { user_id: user.to_param, interest: {} }, headers: valid_session # rubocop:disable Metrics/LineLength
          expect(response.status).to eq(422)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'authorized user' do
      let(:valid_session) do
        user = FactoryGirl.create(:user_with_interests)
        user.create_auth_token
        allow_any_instance_of(described_class).
          to(receive(:current_user).
          and_return(user))
        { token: user.auth_token }
      end

      let(:user) { User.find_by_auth_token(valid_session[:token]) }

      it 'destroys the requested user_interest' do
        user_interest = user.user_interests.first
        expect do
          params = { user_id: user.to_param, user_interest_id: user_interest.to_param }
          delete :destroy, params: params, headers: valid_session
        end.to change(UserInterest, :count).by(-1)
      end

      it 'does *not* destroy the requested user_interest if touched by admin' do
        user_interest = user.user_interests.first
        user_interest.update(level_by_admin: 7)

        expect do
          params = { user_id: user.to_param, user_interest_id: user_interest.to_param }
          delete :destroy, params: params, headers: valid_session
        end.to change(UserInterest, :count).by(0)
      end

      it 'returns no content status' do
        user_interest = user.user_interests.first
        params = { user_id: user.to_param, user_interest_id: user_interest.to_param }
        delete :destroy, params: params, headers: valid_session
        expect(response.status).to eq(204)
      end
    end

    context 'user not allowed' do
      it 'does not destroy the requested user_interest' do
        user = FactoryGirl.create(:user_with_interests)
        user_interest = user.user_interests.first
        expect do
          params = { user_id: user.to_param, user_interest_id: user_interest.to_param }
          delete :destroy, params: params, headers: valid_session
        end.to change(UserInterest, :count).by(0)
      end

      it 'returns not authorized status' do
        user = FactoryGirl.create(:user_with_interests)
        user_interest = user.user_interests.first
        params = { user_id: user.to_param, user_interest_id: user_interest.to_param }
        delete :destroy, params: params, headers: valid_session
        expect(response.status).to eq(403)
      end
    end
  end
end
