require 'rails_helper'

RSpec.describe Api::V1::LanguagesController, type: :controller do
  let(:valid_attributes) do
    { lang_code: 'en' }
  end

  let(:invalid_attributes) do
    { lang_code: nil }
  end

  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'assigns all languages as @languages' do
      language = Language.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:languages)).to eq([language])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested language as @language' do
      language = Language.create! valid_attributes
      get :show, { id: language.to_param }, valid_session
      expect(assigns(:language)).to eq(language)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Language' do
        expect do
          post :create, { language: valid_attributes }, valid_session
        end.to change(Language, :count).by(1)
      end

      it 'assigns a newly created language as @language' do
        post :create, { language: valid_attributes }, valid_session
        expect(assigns(:language)).to be_a(Language)
        expect(assigns(:language)).to be_persisted
      end

      it 'returns created status' do
        post :create, { language: valid_attributes }, valid_session
        expect(response.status).to eq(201)
      end

      context 'not authorized' do
        it 'returns not authorized status' do
          allow_any_instance_of(User).to receive(:admin?).and_return(false)
          post :create, { language: valid_attributes }, valid_session
          expect(response.status).to eq(401)
        end
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved language as @language' do
        post :create, { language: invalid_attributes }, valid_session
        expect(assigns(:language)).to be_a_new(Language)
      end

      it 'returns unprocessable entity status' do
        post :create, { language: invalid_attributes }, valid_session
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        { lang_code: 'ar' }
      end

      it 'updates the requested language' do
        language = Language.create! valid_attributes
        params = { id: language.to_param, language: new_attributes }
        put :update, params, valid_session
        language.reload
        expect(language.lang_code).to eq('ar')
      end

      it 'assigns the requested language as @language' do
        language = Language.create! valid_attributes
        params = { id: language.to_param, language: valid_attributes }
        put :update, params, valid_session
        expect(assigns(:language)).to eq(language)
      end

      it 'returns success status' do
        language = Language.create! valid_attributes
        params = { id: language.to_param, language: valid_attributes }
        put :update, params, valid_session
        expect(response.status).to eq(200)
      end

      context 'not authorized' do
        it 'returns not authorized status' do
          allow_any_instance_of(User).to receive(:admin?).and_return(false)
          language = Language.create! valid_attributes
          params = { id: language.to_param, language: valid_attributes }
          post :update, params, valid_session
          expect(response.status).to eq(401)
        end
      end
    end

    context 'with invalid params' do
      it 'assigns the language as @language' do
        language = Language.create! valid_attributes
        params = { id: language.to_param, language: invalid_attributes }
        put :update, params, valid_session
        expect(assigns(:language)).to eq(language)
      end

      it 'render unprocessable entity status' do
        language = Language.create! valid_attributes
        params = { id: language.to_param, language: invalid_attributes }
        put :update, params, valid_session
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested language' do
      language = Language.create! valid_attributes
      expect do
        delete :destroy, { id: language.to_param }, valid_session
      end.to change(Language, :count).by(-1)
    end

    it 'returns deleted status' do
      language = Language.create! valid_attributes
      delete :destroy, { id: language.to_param }, valid_session
      expect(response.status).to eq(204)
    end

    context 'not authorized' do
      it 'returns not authorized status' do
        allow_any_instance_of(User).to receive(:admin?).and_return(false)
        language = Language.create! valid_attributes
        params = { id: language.to_param }
        post :destroy, params, valid_session
        expect(response.status).to eq(401)
      end
    end
  end
end
