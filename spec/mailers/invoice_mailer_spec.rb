# frozen_string_literal: true
require 'rails_helper'

RSpec.describe InvoiceMailer, type: :mailer do
  let(:user) { mock_model User, name: 'User', email: 'user@example.com' }
  let(:owner) { mock_model User, name: 'Owner', email: 'owner@example.com' }
  let(:job) { mock_model Job, name: 'Job name' }

  describe '#invoice_created_email' do
    let(:mail) do
      described_class.invoice_created_email(job: job, user: user, owner: owner)
    end

    it 'has both text and html part' do
      expect(mail).to be_multipart_email(true)
    end

    it 'renders the subject' do
      subject = 'Congrats! A job you performed has been accepted.'
      expect(mail.subject).to eql(subject)
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['hello@justarrived.se'])
    end

    it 'includes @user_name in email body' do
      expect(mail).to match_email_body(user.name)
    end

    it 'includes @owner_name in email body' do
      expect(mail).to match_email_body(owner.name)
    end

    it 'includes @job_name in email body' do
      expect(mail).to match_email_body(job.name)
    end
  end
end
