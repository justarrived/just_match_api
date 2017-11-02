# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChatMailer, type: :mailer do
  describe '#new_message_email' do
    let(:user) { FactoryBot.create(:user) }
    let(:author) { FactoryBot.create(:user) }
    let(:chat) { FactoryBot.create(:chat, users: [user, author]) }
    let(:message) { FactoryBot.create(:message, author: author) }

    let(:mail) do
      described_class.new_message_email(
        user: user,
        chat: chat,
        message: message,
        author: message.author
      )
    end

    it 'renders the subject' do
      translation = I18n.t('mailer.new_chat_message.subject', name: author.name)
      expect(mail.subject).to eql(translation)
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([user.contact_email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['no-reply@justarrived.se'])
    end

    it 'renders author name' do
      expect(mail).to match_email_body(author.name)
    end

    it 'renders chat URL' do
      chat_url = FrontendRouter.draw(:chat, message_id: message.id)
      expect(mail).to match_email_body(chat_url)
    end

    it 'renders message body' do
      expect(mail).to match_email_body(message.body)
    end
  end
end
