# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::Users::MessagesController, type: :controller do
  let(:valid_session) do
    user = FactoryGirl.create(:user)
    allow_any_instance_of(described_class).
      to(receive(:current_user).
      and_return(user))
    {}
  end

  describe 'GET #index' do
    context 'with valid params' do
      let(:valid_attributes) do
        user = FactoryGirl.create(:user)
        { user_id: user.to_param }
      end

      it 'assigns all messages as @messages' do
        expected_klass = Message::ActiveRecord_Relation
        get :index, params: valid_attributes, headers: valid_session
        expect(assigns(:messages).class).to eq(expected_klass)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      let(:valid_attributes) do
        language = FactoryGirl.create(:language)
        chat_user = FactoryGirl.create(:chat_user)
        user = chat_user.user
        {
          user_id: user.to_param,
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
        chat_user = FactoryGirl.create(:chat_user)
        user = chat_user.user
        {
          user_id: user.to_param, data: {
            attributes: { body: '' }
          }
        }
      end

      it 'does not create a new Message' do
        expect do
          post :create, params: invalid_attributes, headers: valid_session
        end.to change(Message, :count).by(0)
      end

      it 'returns @message errors' do
        post :create, params: invalid_attributes, headers: valid_session
        expect(assigns(:message).errors[:body]).to eq(["can't be blank"])
      end
    end
  end
end
