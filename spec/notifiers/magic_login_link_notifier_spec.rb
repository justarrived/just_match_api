# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MagicLoginLinkNotifier, type: :mailer do
  before(:each) do
    mock = Struct.new(:deliver_later).new(nil)
    allow(UserMailer).to receive(:magic_login_link_email).and_return(mock)
    allow(UserTexter).to receive(:magic_login_link_text).and_return(mock)
  end
  let(:user) { mock_model User, phone?: true }

  it 'calls user mailer' do
    described_class.call(user: user)
    expect(UserMailer).to have_received(:magic_login_link_email).with(user: user).once
  end

  it 'calls job texter' do
    described_class.call(user: user)
    expect(UserTexter).to have_received(:magic_login_link_text).with(user: user).once
  end
end
