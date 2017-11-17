# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Users::UserOccupationsController, type: :controller do
  let(:valid_attributes) do
    {}
  end

  let(:invalid_attributes) do
    {}
  end

  describe 'GET #index' do
    it 'assigns all user occupations as @occupations' do
      user = FactoryBot.create(:user_with_occupations, occupations_count: 2)

      allow_any_instance_of(described_class).
        to(receive(:current_user).
        and_return(user))

      get :index, params: { user_id: user.to_param }

      assigned_occupation_ids = assigns(:user_occupations).map(&:id)
      user_occupation_ids = user.user_occupations.map(&:id)
      expect(assigned_occupation_ids - user_occupation_ids).to be_empty
    end

    it 'returns 200 ok status' do
      user = FactoryBot.create(:user)
      allow_any_instance_of(described_class).
        to(receive(:current_user).
        and_return(user))
      get :index, params: { user_id: user.to_param }
      expect(response.status).to eq(200)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested user occupation as @occupation, @user_occupation, @user' do
      user = FactoryBot.create(:user_with_occupations, occupations_count: 1)
      user_occupation = user.user_occupations.first
      occupation = user_occupation.occupation
      params = {
        auth_token: user.auth_token,
        user_id: user.to_param,
        user_occupation_id: user_occupation.to_param
      }
      get :show, params: params

      expect(assigns(:occupation)).to eq(occupation)
      expect(assigns(:user_occupation)).to eq(user_occupation)
      expect(assigns(:user)).to eq(user)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      context 'authorized user' do
        let(:user) { FactoryBot.create(:user_with_tokens) }

        it 'creates a new UserOccupation' do
          occupation = FactoryBot.create(:occupation)
          params = {
            auth_token: user.auth_token,
            user_id: user.to_param,
            data: {
              attributes: { id: occupation.to_param }
            }
          }
          expect do
            post :create, params: params
          end.to change(UserOccupation, :count).by(1)
        end

        it 'assigns a newly created user_occupation as @user_occupation' do
          occupation = FactoryBot.create(:occupation)
          params = {
            auth_token: user.auth_token,
            user_id: user.to_param,
            data: {
              attributes: { id: occupation.to_param, years_of_experience: 5 }
            }
          }
          post :create, params: params
          expect(assigns(:user_occupation)).to be_a(UserOccupation)
          expect(assigns(:user_occupation)).to be_persisted
          expect(assigns(:user_occupation).years_of_experience).to eq(5)
        end

        it 'returns created status' do
          occupation = FactoryBot.create(:occupation)
          params = {
            auth_token: user.auth_token,
            user_id: user.to_param,
            data: {
              attributes: { id: occupation.to_param }
            }
          }
          post :create, params: params
          expect(response.status).to eq(201)
        end
      end
    end

    context 'not authorized' do
      it 'returns not authorized status' do
        allow_any_instance_of(described_class).
          to(receive(:current_user).
          and_return(User.new))
        user = FactoryBot.create(:user)
        post :create, params: { auth_token: 'wat', user_id: user.to_param, occupation: {} }
        expect(response.status).to eq(401)
      end
    end

    context 'with invalid params' do
      context 'authorized user' do
        let(:user) { FactoryBot.create(:user_with_tokens) }

        it 'assigns a newly created but unsaved user_occupation as @user_occupation' do
          params = { auth_token: user.auth_token, user_id: user.to_param, occupation: {} }
          post :create, params: params
          expect(assigns(:user_occupation)).to be_a_new(UserOccupation)
        end

        it 'returns unprocessable entity status' do
          params = { auth_token: user.auth_token, user_id: user.to_param, occupation: {} }
          post :create, params: params
          expect(response.status).to eq(422)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'authorized user' do
      let(:user) do
        FactoryBot.create(:user_with_occupations).tap do |user|
          user.create_auth_token
          user
        end
      end

      it 'destroys the requested user_occupation' do
        user_occupation = user.user_occupations.first
        params = {
          auth_token: user.auth_token,
          user_id: user.to_param,
          user_occupation_id: user_occupation.to_param
        }
        expect do
          delete :destroy, params: params
        end.to change(UserOccupation, :count).by(-1)
      end

      it 'returns no content status' do
        user_occupation = user.user_occupations.first
        params = {
          auth_token: user.auth_token,
          user_id: user.to_param,
          user_occupation_id: user_occupation.to_param
        }
        delete :destroy, params: params
        expect(response.status).to eq(204)
      end
    end

    context 'user not allowed' do
      it 'does not destroy the requested user_occupation' do
        user = FactoryBot.create(:user_with_occupations)
        user_occupation = user.user_occupations.first
        params = {
          auth_token: user.auth_token,
          user_id: user.to_param,
          user_occupation_id: user_occupation.to_param
        }
        expect do
          delete :destroy, params: params
        end.to change(UserOccupation, :count).by(0)
      end

      it 'returns not authorized status' do
        user = FactoryBot.create(:user_with_occupations)
        other_user = FactoryBot.create(:user_with_tokens)
        user_occupation = user.user_occupations.first
        params = {
          auth_token: other_user.auth_token,
          user_id: user.to_param,
          user_occupation_id: user_occupation.to_param
        }
        delete :destroy, params: params
        expect(response.status).to eq(403)
      end
    end
  end
end
