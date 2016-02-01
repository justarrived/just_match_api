require 'rails_helper'

RSpec.describe Api::V1::Users::MessagesController, type: :controller do
  let(:valid_attributes) do
    lang_id = FactoryGirl.create(:language).id
    {
      skill_ids: [FactoryGirl.create(:skill).id],
      email: 'someone@example.com',
      name: 'Some user name',
      phone: '123456789',
      description: 'Some user description',
      language_id: lang_id,
      language_ids: [lang_id],
      address: 'Stora Nygatan 36, Malmö'
    }
  end

  let(:invalid_attributes) do
    { name: nil }
  end

  let(:valid_session) { {} }

  describe 'GET #messages' do
    context 'with valid params' do
      let(:valid_attributes) do
        user = FactoryGirl.create(:user)
        { user_id: user.to_param }
      end

      it 'assigns all messages as @messages' do
        expected_klass = Message::ActiveRecord_Relation
        get :index, valid_attributes, valid_session
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
          post :create, valid_attributes, valid_session
        end.to change(Message, :count).by(1)
      end

      it 'assigns a newly created message as @message' do
        post :create, valid_attributes, valid_session
        expect(assigns(:message)).to be_a(Message)
        expect(assigns(:message)).to be_persisted
      end

      it 'returns created status' do
        post :create, valid_attributes, valid_session
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
          post :create, invalid_attributes, valid_session
        end.to change(Message, :count).by(0)
      end

      it 'returns @message errors' do
        post :create, invalid_attributes, valid_session
        expect(assigns(:message).errors[:body]).to eq(["can't be blank"])
      end
    end
  end
end
