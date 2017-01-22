# frozen_string_literal: true
require 'rails_helper'

RSpec.describe AdminMailer, type: :mailer do
  let(:company) { mock_model(Company, name: 'ACME') }
  let(:user) { mock_model User, contact_email: 'admin@example.com' }
  let(:job) { mock_model Job, company: company }
  let(:ff_invoice) { mock_model FrilansFinansInvoice, user: user, name: 'ff invoice #1' }

  describe '#invoice_missing_company_frilans_finans_id_email' do
    let(:mail) do
      described_class.invoice_missing_company_frilans_finans_id_email(
        ff_invoice: ff_invoice,
        user: user,
        job: job
      )
    end

    it 'has both text and html part' do
      expect(mail).to be_multipart_email(true)
    end

    it 'renders the subject' do
      subject = I18n.t('admin.mailer.invoice_missing_company_frilans_finans_id.subject')
      expect(mail.subject).to eq(subject)
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([user.contact_email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['support@email.justarrived.se'])
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
      expect(mail).to match_email_body(admin_frilans_finans_invoice_url(ff_invoice))
    end
  end

  describe '#invoice_failed_to_connect_to_frilans_finans_email' do
    let(:mail) do
      described_class.invoice_failed_to_connect_to_frilans_finans_email(
        ff_invoice: ff_invoice,
        user: user
      )
    end

    it 'has both text and html part' do
      expect(mail).to be_multipart_email(true)
    end

    it 'renders the subject' do
      subject = I18n.t('admin.mailer.invoice_failed_to_connect_to_frilans_finans.subject')
      expect(mail.subject).to eq(subject)
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([user.contact_email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['support@email.justarrived.se'])
    end

    it 'includes invoice name in email body' do
      expect(mail).to match_email_body('invoice #1')
    end

    it 'includes invoice link in email body' do
      expect(mail).to match_email_body(admin_frilans_finans_invoice_url(ff_invoice))
    end
  end

  describe '#failed_to_activate_invoice_email' do
    let(:mail) do
      described_class.failed_to_activate_invoice_email(
        ff_invoice: ff_invoice,
        user: user
      )
    end

    it 'has both text and html part' do
      expect(mail).to be_multipart_email(true)
    end

    it 'renders the subject' do
      subject = I18n.t('admin.mailer.failed_to_activate_invoice.subject')
      expect(mail.subject).to eq(subject)
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([user.contact_email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['support@email.justarrived.se'])
    end

    it 'includes invoice name in email body' do
      expect(mail).to match_email_body('invoice for #1')
    end

    it 'includes invoice link in email body' do
      expect(mail).to match_email_body(admin_frilans_finans_invoice_url(ff_invoice))
    end
  end
end
