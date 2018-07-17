# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Users::MessagesController, type: :controller do
  describe 'GET #index' do
    context 'with valid params' do
      let(:valid_attributes) do
        user = FactoryBot.create(:user_with_tokens)
        { auth_token: user.auth_token, user_id: user.to_param }
      end

      it 'assigns all messages as @messages' do
        get :index, params: valid_attributes
        expect(assigns(:messages).length).to eq(0)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      let(:valid_attributes) do
        language = FactoryBot.create(:language)
        chat_user = FactoryBot.create(:chat_user)
        user = chat_user.user
        user.create_auth_token
        {
          auth_token: user.auth_token,
          user_id: user.to_param,
          data: {
            attributes: { body: 'Some test text.', language_id: language }
          }
        }
      end

      it 'creates a new Message' do
        expect do
          post :create, params: valid_attributes
        end.to change(Message, :count).by(1)
      end

      it 'assigns a newly created message as @message' do
        post :create, params: valid_attributes
        expect(assigns(:message)).to be_a(Message)
        expect(assigns(:message)).to be_persisted
      end

      it 'returns created status' do
        post :create, params: valid_attributes
        expect(response.status).to eq(201)
      end
    end

    context 'with invalid params' do
      let(:invalid_attributes) do
        chat_user = FactoryBot.create(:chat_user)
        user = chat_user.user
        user.create_auth_token
        {
          auth_token: user.auth_token,
          user_id: user.to_param, data: {
            attributes: { body: '' }
          }
        }
      end

      it 'does not create a new Message' do
        expect do
          post :create, params: invalid_attributes
        end.to change(Message, :count).by(0)
      end

      it 'returns @message errors' do
        post :create, params: invalid_attributes
        message = I18n.t('errors.messages.blank')
        expect(assigns(:message).errors[:body]).to include(message)
      end
    end
  end
end
