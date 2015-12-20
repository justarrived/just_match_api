require 'rails_helper'

RSpec.describe Api::V1::ChatsController, type: :controller do
  let(:valid_attributes) do
    first = FactoryGirl.create(:user)
    second = FactoryGirl.create(:user)
    { user_ids: [first, second] }
  end

  let(:invalid_attributes) do
    { user_ids: [] }
  end

  let(:valid_session) do
    user = FactoryGirl.create(:user)
    { token: user.auth_token }
  end

  describe 'GET #index' do
    it 'assigns all chats as @chats' do
      chat = Chat.create! {}
      get :index, {}, valid_session
      expect(assigns(:chats)).to eq([chat])
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
      it 'assigns the requested chat as @chat' do
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
          post :create, { chat: valid_attributes }, valid_session
        end.to change(Chat, :count).by(1)
      end

      it 'assigns a newly created chat as @chat' do
        post :create, { chat: valid_attributes }, valid_session
        expect(assigns(:chat)).to be_a(Chat)
        expect(assigns(:chat)).to be_persisted
      end

      it 'returns created status' do
        post :create, { chat: valid_attributes }, valid_session
        expect(response.status).to eq(201)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved chat as @chat' do
        FactoryGirl.create(:user)
        post :create, { chat: invalid_attributes }, valid_session
        expect(assigns(:chat)).to be_a_new(Chat)
      end

      it 'returns @chat errors' do
        FactoryGirl.create(:user)
        post :create, { chat: invalid_attributes }, valid_session
        expect(assigns(:chat).errors[:users]).to eq(['must be between 2-10'])
      end
    end
  end
end
