# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserTexter do
  let(:one_time_token) { 'watwoman' }
  let(:user) { FactoryGirl.build(:user, one_time_token: one_time_token) }

  before(:each) do
    allow(AppSecrets).to receive(:twilio_account_sid).and_return('notsosecret')
    allow(AppSecrets).to receive(:twilio_auth_token).and_return('notsosecret')
  end

  describe '#applicant_accepted_text' do
    let!(:text) do
      described_class.magic_login_link_text(user: user).deliver_now
    end
    let(:last_message_body) { FakeSMS.messages.last.body }

    it 'renders the frontend URL for the magic login link' do
      url = FrontendRouter.draw(:magic_login_link, token: one_time_token)
      expect(last_message_body).to match(url)
    end
  end
end
