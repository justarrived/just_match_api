# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::Users::UserLanguagesController, type: :controller do
  let(:valid_attributes) do
    {}
  end

  let(:invalid_attributes) do
    {}
  end

  let(:valid_session) do
    user = FactoryGirl.create(:user)
    allow_any_instance_of(described_class).
      to(receive(:authenticate_user_token!).
      and_return(user))
    { token: user.auth_token }
  end

  let(:user) { User.find_by(auth_token: valid_session[:token]) }

  describe 'GET #index' do
    it 'assigns all user languages as @languages' do
      user = FactoryGirl.create(:user_with_languages, languages_count: 1)

      allow_any_instance_of(described_class).
        to(receive(:authenticate_user_token!).
        and_return(user))

      user_language = user.user_languages.first
      get :index, { user_id: user.to_param }, {}
      expect(assigns(:user_languages)).to eq([user_language])
    end
  end

  describe 'GET #show' do
    it 'assigns @language, @user @user_language' do
      user = FactoryGirl.create(:user_with_languages, languages_count: 1)
      language = user.languages.first
      user_language = user.user_languages.first
      get :show, { user_id: user.to_param, id: user_language.to_param }, valid_session
      expect(assigns(:language)).to eq(language)
      expect(assigns(:user_language)).to eq(user_language)
      expect(assigns(:user)).to eq(user)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new UserLanguage' do
        language = FactoryGirl.create(:language)
        params = {
          user_id: user.to_param,
          data: {
            attributes: { id: language.to_param }
          }
        }
        expect do
          post :create, params, valid_session
        end.to change(UserLanguage, :count).by(1)
      end

      it 'assigns a newly created user_language as @user_language' do
        language = FactoryGirl.create(:language)
        params = {
          user_id: user.to_param,
          data: {
            attributes: { id: language.to_param }
          }
        }
        post :create, params, valid_session
        expect(assigns(:user_language)).to be_a(UserLanguage)
        expect(assigns(:user_language)).to be_persisted
      end

      it 'returns created status' do
        language = FactoryGirl.create(:language)
        params = {
          user_id: user.to_param,
          data: {
            attributes: { id: language.to_param }
          }
        }
        post :create, params, valid_session
        expect(response.status).to eq(201)
      end

      context 'not authorized' do
        it 'returns created status' do
          user = FactoryGirl.create(:user)
          language = FactoryGirl.create(:language)
          params = {
            user_id: user.to_param,
            data: {
              attributes: { id: language.to_param }
            }
          }
          post :create, params, valid_session
          expect(response.status).to eq(401)
        end
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved user_language as @user_language' do
        params = { user_id: user.to_param, language: { id: nil } }
        post :create, params, valid_session
        expect(assigns(:user_language)).to be_a_new(UserLanguage)
      end

      it 'returns unprocessable entity status' do
        params = { user_id: user.to_param, language: { id: nil } }
        post :create, params, valid_session
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'authorized' do
      it 'destroys the requested user_language' do
        user_language = FactoryGirl.create(:user_language, user: user)
        params = { user_id: user.to_param, id: user_language.to_param }
        expect do
          delete :destroy, params, valid_session
        end.to change(UserLanguage, :count).by(-1)
      end

      it 'returns no content status' do
        user_language = FactoryGirl.create(:user_language, user: user)
        params = { user_id: user.to_param, id: user_language.to_param }
        delete :destroy, params, valid_session
        expect(response.status).to eq(204)
      end
    end

    context 'not authorized' do
      it 'does not destroys the requested user_language' do
        user = FactoryGirl.create(:user_with_languages)
        user_language = user.user_languages.first
        params = { user_id: user.to_param, id: user_language.to_param }
        expect do
          delete :destroy, params, valid_session
        end.to change(UserLanguage, :count).by(0)
      end

      it 'returns not authorized error' do
        user = FactoryGirl.create(:user_with_languages)
        user_language = user.user_languages.first
        params = { user_id: user.to_param, id: user_language.to_param }
        delete :destroy, params, valid_session
        expect(response.status).to eq(401)
      end
    end
  end
end
