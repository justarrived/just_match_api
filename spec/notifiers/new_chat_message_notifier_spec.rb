# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewChatMessageNotifier, type: :mailer do
  let(:mailer) { Struct.new(:deliver_later).new(nil) }
  let(:user) { FactoryBot.create(:user) }
  let(:author) { FactoryBot.create(:user) }
  let(:message) { FactoryBot.create(:message, author: author) }
  let(:chat) { FactoryBot.create(:chat, users: [user, author]) }

  it 'sends notifications' do
    allow(ChatMailer).to receive(:new_message_email).and_return(mailer)
    described_class.call(chat: chat, message: message, author: author)
    expect(ChatMailer).to have_received(:new_message_email).once
  end
end
