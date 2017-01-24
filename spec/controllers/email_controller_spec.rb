# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::EmailController, type: :controller do
  let(:ja_key) { 'notsosecret' }
  let(:email) { 'from_user_email@example.com' }
  let(:params) do
    {
      'ja_key' => ja_key,
      'from' => email,
      'subject' => 'Email subject',
      'body' => 'Something, somthing darkside...'
    }
  end

  describe 'POST #receive' do
    it 'creates message' do
      allow(AppSecrets).to receive(:incoming_email_key).and_return(ja_key)
      FactoryGirl.create(:admin_user)
      FactoryGirl.create(:user, email: email)

      expect do
        post :receive, params: params
      end.to change(Message, :count).by(1)
      expect(response.status).to eq(204)
    end

    it 'creates message' do
      allow(AppSecrets).to receive(:incoming_email_key).and_return(ja_key)
      FactoryGirl.create(:admin_user)
      FactoryGirl.create(:user, email: email)

      expect do
        post :receive, params: params
      end.to change(ReceivedEmail, :count).by(1)
      expect(response.status).to eq(204)
    end

    it 'returns 204 if no user found' do
      allow(AppSecrets).to receive(:incoming_email_key).and_return(ja_key)
      post :receive, params: params
      expect(response.status).to eq(204)
    end

    it 'returns unauthorized status unless the correct key is passed' do
      allow(AppSecrets).to receive(:incoming_email_key).and_return('not-the-key')
      post :receive
      expect(response.status).to eq(401)
    end
  end
end
