# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::ChatsController, type: :controller do
  let(:valid_attributes) do
    user = FactoryGirl.create(:user)
    {
      data: {
        attributes: { user_ids: [user] }
      }
    }
  end

  let(:invalid_attributes) do
    {
      data: {
        attributes: { user_ids: [] }
      }
    }
  end

  let(:valid_session) do
    user = FactoryGirl.create(:user)
    allow_any_instance_of(described_class).
      to(
        receive(:authenticate_user_token!).
        and_return(user)
      )
    { token: user.auth_token }
  end

  describe 'GET #index' do
    it 'assigns all chats as @chats' do
      allow_any_instance_of(User).to receive(:admin?).and_return(true)
      chat = Chat.create! {}
      get :index, {}, valid_session
      expect(assigns(:chats)).to eq([chat])
    end

    context 'not authorized' do
      it 'returns not authorized status' do
        allow_any_instance_of(User).to receive(:admin?).and_return(false)
        get :index, {}, valid_session
        expect(response.status).to eq(401)
      end
    end
  end

  describe 'GET #show' do
    context 'authorized' do
      it 'assigns the requested chat as @chat' do
        user = User.find_by(auth_token: valid_session[:token])
        chat_user = FactoryGirl.create(:chat_user, user: user)
        chat = chat_user.chat
        get :show, { id: chat.to_param }, valid_session
        expect(assigns(:chat)).to eq(chat)
      end
    end

    context 'non authorized' do
      it 'raises record not found error' do
        chat_user = FactoryGirl.create(:chat_user)
        chat = chat_user.chat
        expect do
          get :show, { id: chat.to_param }, valid_session
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Chat' do
        expect do
          post :create, valid_attributes, valid_session
        end.to change(Chat, :count).by(1)
      end

      it 'assigns a newly created chat as @chat' do
        post :create, valid_attributes, valid_session
        expect(assigns(:chat)).to be_a(Chat)
        expect(assigns(:chat)).to be_persisted
      end

      it 'returns created status' do
        post :create, valid_attributes, valid_session
        expect(response.status).to eq(201)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved chat as @chat' do
        FactoryGirl.create(:user)
        post :create, invalid_attributes, valid_session
        expect(assigns(:chat)).to be_a_new(Chat)
      end

      it 'returns @chat errors' do
        FactoryGirl.create(:user)
        post :create, invalid_attributes, valid_session
        min = Chat::MIN_USERS
        max = Chat::MAX_USERS
        message = I18n.t('errors.chat.number_of_users', min: min, max: max)
        expect(assigns(:chat).errors[:users]).to eq([message])
      end

      it 'returns unprocessable entity' do
        FactoryGirl.create(:user)
        post :create, invalid_attributes, valid_session
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
