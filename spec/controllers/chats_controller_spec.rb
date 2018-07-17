# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Chats::ChatsController, type: :controller do
  let(:user) { FactoryBot.create(:user_with_tokens) }
  let(:valid_attributes) do
    {
      auth_token: user.auth_token,
      data: {
        attributes: { user_ids: [FactoryBot.create(:user)] }
      }
    }
  end

  let(:invalid_attributes) do
    {
      auth_token: user.auth_token,
      data: {
        attributes: { user_ids: [] }
      }
    }
  end

  describe 'GET #index' do
    it 'assigns all chats as @chats' do
      admin_user = FactoryBot.create(:user_with_tokens, admin: true)
      chat = Chat.create! {}
      process :index, method: :get, params: { auth_token: admin_user.auth_token }
      expect(assigns(:chats)).to eq([chat])
    end

    context 'not authorized' do
      it 'returns not authorized status' do
        random_user = FactoryBot.create(:user_with_tokens)
        process :index, method: :get, params: { auth_token: random_user.auth_token }
        expect(response.status).to eq(403)
      end
    end
  end

  describe 'GET #show' do
    context 'authorized' do
      it 'assigns the requested chat as @chat' do
        chat_user = FactoryBot.create(:chat_user, user: user)
        chat = chat_user.chat
        params = { auth_token: user.auth_token, id: chat.to_param }
        process :show, method: :get, params: params
        expect(assigns(:chat)).to eq(chat)
      end
    end

    context 'non authorized' do
      it 'raises record not found error' do
        chat_user = FactoryBot.create(:chat_user)
        chat = chat_user.chat
        params = { auth_token: user.auth_token, id: chat.to_param }
        process :show, method: :get, params: params
        expect(response.status).to eq(404)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Chat' do
        expect do
          process :create, method: :post, params: valid_attributes
        end.to change(Chat, :count).by(1)
      end

      it 'assigns a newly created chat as @chat' do
        process :create, method: :post, params: valid_attributes
        expect(assigns(:chat)).to be_a(Chat)
        expect(assigns(:chat)).to be_persisted
      end

      it 'returns created status' do
        process :create, method: :post, params: valid_attributes
        expect(response.status).to eq(201)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved chat as @chat' do
        FactoryBot.create(:user)
        process :create, method: :post, params: invalid_attributes
        expect(assigns(:chat)).to be_a_new(Chat)
      end

      it 'returns @chat errors' do
        FactoryBot.create(:user)
        process :create, method: :post, params: invalid_attributes
        min = Chat::MIN_USERS
        max = Chat::MAX_USERS
        message = I18n.t('errors.chat.number_of_users', min: min, max: max)
        expect(assigns(:chat).errors[:users]).to eq([message])
      end

      it 'returns unprocessable entity' do
        FactoryBot.create(:user)
        process :create, method: :post, params: invalid_attributes
        expect(response.status).to eq(422)
      end
    end
  end
end

# == Schema Information
#
# Table name: chats
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
