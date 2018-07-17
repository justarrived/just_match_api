# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::SmsController, type: :controller do
  let(:ja_key) { 'notsosecret' }
  let(:phone) { '+46735013001' }
  let(:params) do
    {
      'ja_key' => ja_key,
      'From' => phone,
      'Body' => 'Something, somthing darkside...'
    }
  end

  describe 'POST #receive' do
    it 'creates message' do
      allow(AppSecrets).to receive(:incoming_sms_key).and_return(ja_key)
      FactoryBot.create(:admin_user)
      FactoryBot.create(:user, phone: phone)

      expect do
        post :receive, params: params
      end.to change(Message, :count).by(1)
      expect(response.status).to eq(204)
    end

    it 'creates message' do
      allow(AppSecrets).to receive(:incoming_sms_key).and_return(ja_key)
      FactoryBot.create(:admin_user)
      FactoryBot.create(:user, phone: phone)

      expect do
        post :receive, params: params
      end.to change(ReceivedText, :count).by(1)
      expect(response.status).to eq(204)
    end

    it 'returns 204 if no user found' do
      allow(AppSecrets).to receive(:incoming_sms_key).and_return(ja_key)
      post :receive, params: params
      expect(response.status).to eq(204)
    end

    it 'returns unauthorized status unless the correct key is passed' do
      allow(AppSecrets).to receive(:incoming_sms_key).and_return('not-the-key')
      post :receive
      expect(response.status).to eq(401)
    end
  end
end
