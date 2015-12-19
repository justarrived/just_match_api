require 'rails_helper'

RSpec.describe Api::V1::UserSessionsController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # Chat. As you add validations to Chat, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    { email: 'someone@example.com', password: '12345678' }
  end

  let(:invalid_attributes) do
    {}
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ChatsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe 'POST #token' do
    context 'valid user' do
      before(:all) do
        FactoryGirl.create(:user, email: 'someone@example.com')
      end

      it 'should return success status' do
        post :token, valid_attributes, valid_session
        expect(response.status).to eq(200)
      end

      it 'should return JSON with token key' do
        post :token, valid_attributes, valid_session
        json = JSON.parse(response.body)
        expect(json['token'].length).to eq(32)
      end
    end

    context 'invalid user' do
      it 'should return forbidden status' do
        post :token, valid_attributes, valid_session
        expect(response.status).to eq(403)
      end
    end
  end
end
