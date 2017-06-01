# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SMSClient do
  context 'credentials' do
    before(:each) do
      allow(ENV).to receive(:[]).with('TWILIO_ACCOUNT_SID').and_return(nil)
      allow(ENV).to receive(:[]).with('TWILIO_AUTH_TOKEN').and_return(nil)
    end

    it 'fails if account sid is *not* set' do
      expect do
        described_class.new(account_sid: nil, auth_token: 'XYZ')
      end.to raise_error(SMSClient::MissingTwilioAccountSidError)
    end

    it 'fails if auth token is *not* set' do
      expect do
        described_class.new(account_sid: 'XYZ', auth_token: nil)
      end.to raise_error(SMSClient::MissingTwilioAuthTokenError)
    end
  end

  describe '#send_message' do
    let(:account_sid) { 'XYZ' }
    let(:auth_token) { 'XYZ' }
    let(:from) { '+46735000000' }
    let(:to) { '+46735000000' }
    let(:body) { 'Watman!' }
    subject { described_class.new(account_sid: account_sid, auth_token: auth_token) }

    it 'sends text message' do
      subject.send_message(from: from, to: to, body: body)
      last_message = FakeSMS.messages.last

      expect(last_message.from).to eq(from)
      expect(last_message.to).to eq(to)
      expect(last_message.body).to eq(body)
    end
  end
end
