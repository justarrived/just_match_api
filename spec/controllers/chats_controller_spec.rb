require 'rails_helper'

RSpec.describe Api::V1::ChatsController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # Chat. As you add validations to Chat, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    first = FactoryGirl.create(:user)
    second = FactoryGirl.create(:user)
    { user_ids: [first, second] }
  }

  let(:invalid_attributes) {
    { user_ids: [] }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ChatsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'assigns all chats as @chats' do
      chat = Chat.create! {}
      get :index, {}, valid_session
      expect(assigns(:chats)).to eq([chat])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested chat as @chat' do
      chat_user = FactoryGirl.create(:chat_user)
      chat = chat_user.chat
      user = chat_user.user
      get :show, {id: chat.to_param}, valid_session
      expect(assigns(:chat)).to eq(chat)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Chat' do
        expect {
          post :create, {chat: valid_attributes}, valid_session
        }.to change(Chat, :count).by(1)
      end

      it 'assigns a newly created chat as @chat' do
        post :create, {chat: valid_attributes}, valid_session
        expect(assigns(:chat)).to be_a(Chat)
        expect(assigns(:chat)).to be_persisted
      end

      it 'returns created status' do
        post :create, {chat: valid_attributes}, valid_session
        expect(response.status).to eq(201)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved chat as @chat' do
        FactoryGirl.create(:user)
        post :create, {chat: invalid_attributes}, valid_session
        expect(assigns(:chat)).to be_a_new(Chat)
      end

      it 'returns @chat errors' do
        FactoryGirl.create(:user)
        post :create, {chat: invalid_attributes}, valid_session
        expect(assigns(:chat).errors[:users]).to eq(['must be more than one'])
      end
    end
  end

  describe 'GET #messages' do
    context 'with valid params' do
      let(:valid_attributes) do
        chat_user = FactoryGirl.create(:chat_user)
        chat = chat_user.chat
        user = chat_user.user
        FactoryGirl.create(:message, chat: chat, author: user)
        { id: chat.to_param }
      end

      it 'assigns all messages as @messages' do
        get :messages, valid_attributes, valid_session
        expect(assigns(:messages).first).to be_a(Message)
      end
    end
  end

  describe 'POST #create_message' do
    context 'with valid params' do
      let(:valid_attributes) do
        language = FactoryGirl.create(:language)
        chat_user = FactoryGirl.create(:chat_user)
        chat = chat_user.chat
        {
          id: chat.to_param,
          message: { body: 'Some test text.', language_id: language }
        }
      end

      it 'creates a new Message' do
        expect {
          post :create_message, valid_attributes, valid_session
        }.to change(Message, :count).by(1)
      end

      it 'assigns chat as @chat' do
        post :create_message, valid_attributes, valid_session
        expect(assigns(:chat)).to be_a(Chat)
        expect(assigns(:chat)).to be_persisted
      end

      it 'assigns a newly created message as @message' do
        post :create_message, valid_attributes, valid_session
        expect(assigns(:message)).to be_a(Message)
        expect(assigns(:message)).to be_persisted
      end

      it 'returns created status' do
        post :create_message, valid_attributes, valid_session
        expect(response.status).to eq(201)
      end
    end

    context 'with invalid params' do
      let(:invalid_attributes) do
        chat_user = FactoryGirl.create(:chat_user)
        chat = chat_user.chat
        { id: chat.to_param, message: { body: '' } }
      end

      it 'assigns chat as @chat' do
        post :create_message, invalid_attributes, valid_session
        expect(assigns(:chat)).to be_a(Chat)
      end

      it 'returns @message errors' do
        post :create_message, invalid_attributes, valid_session
        expect(assigns(:message).errors[:body]).to eq(["can't be blank"])
      end
    end
  end
end
