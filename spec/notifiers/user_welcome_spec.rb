# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserWelcomeNotifier, type: :mailer do
  let(:mailer) { Struct.new(:deliver_later).new(nil) }

  it 'must work' do
    allow(UserMailer).to receive(:welcome_email).and_return(mailer)
    UserWelcomeNotifier.call(user: nil)
    expect(UserMailer).to have_received(:welcome_email).with(user: nil)
  end
end
