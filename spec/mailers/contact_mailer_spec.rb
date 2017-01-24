# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ContactMailer, type: :mailer do
  describe '#contact_email' do
    let(:name) { 'Watman' }
    let(:email) { 'test@example.com' }
    let(:body) { 'body' }

    let(:mail) do
      described_class.contact_email(name: name, email: email, body: body)
    end

    it 'renders the subject' do
      expect(mail.subject).to eql(['Mail from', name, email].join(' '))
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql(['no-reply@justarrived.se'])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['no-reply@justarrived.se'])
    end

    it 'renders body' do
      expect(mail.body.encoded).to match(body)
    end
  end
end
