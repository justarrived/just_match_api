# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MessageCreatedNotifier, type: :mailer do
  let(:mailer) { Struct.new(:deliver_later).new(nil) }
  let(:user) { FactoryGirl.create(:user) }
  let(:author) { FactoryGirl.create(:user) }
  let(:message) { FactoryGirl.create(:message, author: author) }
  let(:chat) { FactoryGirl.create(:chat, users: [user, author]) }

  it 'sends notifications' do
    allow(ChatMailer).to receive(:new_message_email).and_return(mailer)
    described_class.call(chat: chat, message: message, author: author)
    expect(ChatMailer).to have_received(:new_message_email).once
  end
end
