# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::LanguagesController, type: :controller do
  before(:each) do
    allow_any_instance_of(User).to receive(:persisted?).and_return(true)
  end

  let(:valid_attributes) do
    {
      data: {
        attributes: { lang_code: 'en' }
      }
    }
  end

  let(:invalid_attributes) do
    {
      data: {
        attributes: { lang_code: nil }
      }
    }
  end

  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'assigns all languages as @languages' do
      language = FactoryGirl.create(:language)
      process :index, method: :get, headers: valid_session
      expect(assigns(:languages)).to eq([language])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested language as @language' do
      language = FactoryGirl.create(:language)
      get :show, params: { id: language.to_param }, headers: valid_session
      expect(assigns(:language)).to eq(language)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Language' do
        allow_any_instance_of(User).to receive(:admin?).and_return(true)
        expect do
          post :create, params: valid_attributes, headers: valid_session
        end.to change(Language, :count).by(1)
      end

      it 'assigns a newly created language as @language' do
        allow_any_instance_of(User).to receive(:admin?).and_return(true)
        post :create, params: valid_attributes, headers: valid_session
        expect(assigns(:language)).to be_a(Language)
        expect(assigns(:language)).to be_persisted
      end

      it 'returns created status' do
        allow_any_instance_of(User).to receive(:admin?).and_return(true)
        post :create, params: valid_attributes, headers: valid_session
        expect(response.status).to eq(201)
      end

      context 'not authorized' do
        it 'returns not authorized status' do
          allow_any_instance_of(User).to receive(:admin?).and_return(false)
          post :create, params: valid_attributes, headers: valid_session
          expect(response.status).to eq(403)
        end
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved language as @language' do
        allow_any_instance_of(User).to receive(:admin?).and_return(true)
        post :create, params: invalid_attributes, headers: valid_session
        expect(assigns(:language)).to be_a_new(Language)
      end

      it 'returns unprocessable entity status' do
        allow_any_instance_of(User).to receive(:admin?).and_return(true)
        post :create, params: invalid_attributes, headers: valid_session
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        {
          data: {
            attributes: { lang_code: 'ar' }
          }
        }
      end

      it 'updates the requested language' do
        allow_any_instance_of(User).to receive(:admin?).and_return(true)
        language = FactoryGirl.create(:language)
        params = { id: language.to_param }.merge(new_attributes)
        put :update, params: params, headers: valid_session
        language.reload
        expect(language.lang_code).to eq('ar')
      end

      it 'assigns the requested language as @language' do
        language = FactoryGirl.create(:language, lang_code: 'ar')
        params = { id: language.to_param }.merge(new_attributes)
        put :update, params: params, headers: valid_session
        expect(assigns(:language)).to eq(language)
      end

      it 'returns success status' do
        allow_any_instance_of(User).to receive(:admin?).and_return(true)
        language = FactoryGirl.create(:language)
        params = { id: language.to_param }.merge(new_attributes)
        put :update, params: params, headers: valid_session
        expect(response.status).to eq(200)
      end

      context 'not authorized' do
        it 'returns not authorized status' do
          allow_any_instance_of(User).to receive(:admin?).and_return(false)
          language = FactoryGirl.create(:language)
          params = { id: language.to_param }.merge(new_attributes)
          post :update, params: params, headers: valid_session
          expect(response.status).to eq(403)
        end
      end
    end

    context 'with invalid params' do
      it 'assigns the language as @language' do
        language = FactoryGirl.create(:language)
        params = { id: language.to_param }.merge(invalid_attributes)
        put :update, params: params, headers: valid_session
        expect(assigns(:language)).to eq(language)
      end

      it 'render unprocessable entity status' do
        allow_any_instance_of(User).to receive(:admin?).and_return(true)
        language = FactoryGirl.create(:language)
        params = { id: language.to_param }.merge(invalid_attributes)
        put :update, params: params, headers: valid_session
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested language' do
      allow_any_instance_of(User).to receive(:admin?).and_return(true)
      language = FactoryGirl.create(:language)
      expect do
        delete :destroy, params: { id: language.to_param }, headers: valid_session
      end.to change(Language, :count).by(-1)
    end

    it 'returns deleted status' do
      allow_any_instance_of(User).to receive(:admin?).and_return(true)
      language = FactoryGirl.create(:language)
      delete :destroy, params: { id: language.to_param }, headers: valid_session
      expect(response.status).to eq(204)
    end

    context 'not authorized' do
      it 'returns not authorized status' do
        allow_any_instance_of(User).to receive(:admin?).and_return(false)
        language = FactoryGirl.create(:language)
        params = { id: language.to_param }
        post :destroy, params: params, headers: valid_session
        expect(response.status).to eq(403)
      end
    end
  end
end

# == Schema Information
#
# Table name: languages
#
#  id              :integer          not null, primary key
#  lang_code       :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  en_name         :string
#  direction       :string
#  local_name      :string
#  system_language :boolean          default(FALSE)
#  sv_name         :string
#  ar_name         :string
#  fa_name         :string
#  fa_af_name      :string
#  ku_name         :string
#  ti_name         :string
#  ps_name         :string
#
# Indexes
#
#  index_languages_on_lang_code  (lang_code) UNIQUE
#
