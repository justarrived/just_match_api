# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ResetPasswordNotifier, type: :mailer do
  let(:mailer) { Struct.new(:deliver_later).new(nil) }
  let(:user) { FactoryGirl.build(:user_with_one_time_token) }

  it 'must work' do
    allow(UserMailer).to receive(:reset_password_email).and_return(mailer)
    described_class.call(user: user)
    expect(UserMailer).to have_received(:reset_password_email).with(user: user)
  end
end
