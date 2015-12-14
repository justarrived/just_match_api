require 'rails_helper'

RSpec.describe Api::V1::Users::UserLanguagesController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # UserLanguage. As you add validations to UserLanguage, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    {}
  end

  let(:invalid_attributes) do
    {}
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # UserLanguagesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'assigns all user languages as @languages' do
      user = FactoryGirl.create(:user_with_languages, languages_count: 1)
      language = user.languages.first
      get :index, { user_id: user.to_param }, valid_session
      expect(assigns(:languages)).to eq([language])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested user language as @language' do
      user = FactoryGirl.create(:user_with_languages, languages_count: 1)
      language = user.languages.first
      get :show, { user_id: user.to_param, id: language.to_param }, valid_session
      expect(assigns(:language)).to eq(language)
    end

    it 'assigns the requested user as @user' do
      user = FactoryGirl.create(:user_with_languages, languages_count: 1)
      language = user.languages.first
      get :show, { user_id: user.to_param, id: language.to_param }, valid_session
      expect(assigns(:user)).to eq(user)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new UserLanguage' do
        user = FactoryGirl.create(:user)
        language = FactoryGirl.create(:language)
        params = { user_id: user.to_param, language: { id: language.to_param } }
        expect do
          post :create, params, valid_session
        end.to change(UserLanguage, :count).by(1)
      end

      it 'assigns a newly created user_language as @user_language' do
        user = FactoryGirl.create(:user)
        language = FactoryGirl.create(:language)
        params = { user_id: user.to_param, language: { id: language.to_param } }
        post :create, params, valid_session
        expect(assigns(:user_language)).to be_a(UserLanguage)
        expect(assigns(:user_language)).to be_persisted
      end

      it 'returns created status' do
        user = FactoryGirl.create(:user)
        language = FactoryGirl.create(:language)
        params = { user_id: user.to_param, language: { id: language.to_param } }
        post :create, params, valid_session
        expect(response.status).to eq(201)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved user_language as @user_language' do
        user = FactoryGirl.create(:user)
        params = { user_id: user.to_param, language: { id: nil } }
        post :create, params, valid_session
        expect(assigns(:user_language)).to be_a_new(UserLanguage)
      end

      it 'returns unprocessable entity status' do
        user = FactoryGirl.create(:user)
        params = { user_id: user.to_param, language: { id: nil } }
        post :create, params, valid_session
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested user_language' do
      user = FactoryGirl.create(:user_with_languages)
      language = user.languages.first
      params = { user_id: user.to_param, id: language.to_param }
      expect do
        delete :destroy, params, valid_session
      end.to change(UserLanguage, :count).by(-1)
    end

    it 'returns no content status' do
      user = FactoryGirl.create(:user_with_languages)
      language = user.languages.first
      params = { user_id: user.to_param, id: language.to_param }
      delete :destroy, params, valid_session
      expect(response.status).to eq(204)
    end
  end
end
