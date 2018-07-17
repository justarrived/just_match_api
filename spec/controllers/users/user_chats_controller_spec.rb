# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Users::UserChatsController, type: :controller do
  let(:user) { FactoryBot.create(:user_with_tokens) }

  describe 'GET #index' do
    context 'with valid params' do
      let(:valid_params) do
        {
          auth_token: user.auth_token,
          user_id: user.to_param
        }
      end

      it 'assigns all chats as @chats' do
        chat = FactoryBot.create(:chat, users: [user])
        get :index, params: valid_params
        expect(assigns(:chats)).to eq([chat])
      end
    end
  end

  describe 'GET #show' do
    context 'with valid params' do
      let(:chat) { FactoryBot.create(:chat, users: [user]) }
      let(:valid_params) do
        {
          auth_token: user.auth_token,
          user_id: user.to_param,
          id: chat.to_param
        }
      end

      it 'assigns chat as @chat' do
        get :show, params: valid_params
        expect(assigns(:chat)).to eq(chat)
      end
    end
  end

  describe 'GET #support_chat' do
    context 'with valid params' do
      let(:valid_params) do
        { auth_token: user.auth_token, user_id: user.to_param }
      end

      it 'assigns chat as @chat' do
        admin_user = FactoryBot.create(:admin_user)
        chat = FactoryBot.create(:chat, users: [user, admin_user])
        get :support_chat, params: valid_params
        expect(assigns(:chat)).to eq(chat)
      end
    end
  end
end
