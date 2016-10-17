# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::Chats::ChatMessagesController, type: :controller do
  before(:each) do
    @chat_user = FactoryGirl.create(:chat_user)
  end

  let(:valid_attributes) do
    first = FactoryGirl.create(:user)
    second = FactoryGirl.create(:user)
    { user_ids: [first, second] }
  end

  let(:invalid_attributes) do
    { user_ids: [] }
  end

  let(:valid_session) do
    user = @chat_user.user
    user.create_auth_token
    allow_any_instance_of(described_class).
      to(receive(:current_user).
      and_return(user))
    { token: user.auth_token }
  end

  describe 'GET #index' do
    context 'with valid params' do
      let(:valid_attributes) do
        chat = @chat_user.chat
        user = @chat_user.user
        FactoryGirl.create(:message, chat: chat, author: user)
        { id: chat.to_param }
      end

      it 'assigns all messages as @messages' do
        get :index, params: valid_attributes, headers: valid_session
        expect(assigns(:messages).first).to be_a(Message)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      let(:valid_attributes) do
        language = FactoryGirl.create(:language)
        chat = @chat_user.chat
        {
          id: chat.to_param,
          data: {
            attributes: { body: 'Some test text.', language_id: language }
          }
        }
      end

      it 'creates a new Message' do
        expect do
          post :create, params: valid_attributes, headers: valid_session
        end.to change(Message, :count).by(1)
      end

      it 'assigns chat as @chat' do
        post :create, params: valid_attributes, headers: valid_session
        expect(assigns(:chat)).to be_a(Chat)
        expect(assigns(:chat)).to be_persisted
      end

      it 'assigns a newly created message as @message' do
        post :create, params: valid_attributes, headers: valid_session
        expect(assigns(:message)).to be_a(Message)
        expect(assigns(:message)).to be_persisted
      end

      it 'returns created status' do
        post :create, params: valid_attributes, headers: valid_session
        expect(response.status).to eq(201)
      end
    end

    context 'with invalid params' do
      let(:invalid_attributes) do
        chat = @chat_user.chat
        { id: chat.to_param, message: { body: '' } }
      end

      it 'assigns message as @message' do
        post :create, params: invalid_attributes, headers: valid_session
        expect(assigns(:message)).to be_a(Message)
      end

      it 'returns @message errors' do
        post :create, params: invalid_attributes, headers: valid_session
        expect(assigns(:message).errors[:body]).to eq(["can't be blank"])
      end
    end
  end
end
