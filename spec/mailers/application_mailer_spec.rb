# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationMailer, type: :mailer do
  describe '#product_information_email' do
    let(:user) { FactoryBot.build_stubbed(:user) }
    let(:subject) { 'subject' }
    let(:body) { 'body' }

    let(:mail) do
      described_class.product_information_email(user: user, subject: subject, body: body)
    end

    it 'renders the subject' do
      expect(mail.subject).to eql(subject)
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['no-reply@justarrived.se'])
    end

    it 'renders body' do
      expect(mail.body.encoded).to match(body)
    end
  end
end
