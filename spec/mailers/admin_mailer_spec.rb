# frozen_string_literal: true
require 'rails_helper'

RSpec.describe AdminMailer, type: :mailer do
  let(:company) { mock_model(Company, name: 'ACME') }
  let(:user) { mock_model User, email: 'admin@example.com' }
  let(:job) { mock_model Job, company: company }
  let(:invoice) { mock_model Invoice, job: job, name: 'invoice #1' }

  describe '#invoice_missing_company_frilans_finans_id_email' do
    let(:mail) do
      described_class.invoice_missing_company_frilans_finans_id_email(
        invoice: invoice,
        user: user
      )
    end

    it 'has both text and html part' do
      expect(mail).to be_multipart_email(true)
    end

    it 'renders the subject' do
      subject = I18n.t('admin..mailer.invoice_missing_company_frilans_finans_id.subject')
      expect(mail.subject).to eq(subject)
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['hello@justarrived.se'])
    end

    it 'includes company name in email body' do
      expect(mail).to match_email_body(company.name)
    end

    it 'includes company link in email body' do
      expect(mail).to match_email_body(admin_company_url(company))
    end

    it 'includes invoice name in email body' do
      expect(mail).to match_email_body('invoice #1')
    end

    it 'includes invoice link in email body' do
      expect(mail).to match_email_body(admin_invoice_url(invoice))
    end
  end
end
