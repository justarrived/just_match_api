# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CreateInvoiceService, type: :serializer do
  let(:company) { FactoryGirl.create(:company, frilans_finans_id: 1) }
  let(:job) do
    owner = FactoryGirl.create(:user, company: company)
    FactoryGirl.create(:passed_job, owner: owner)
  end
  let(:job_user) { FactoryGirl.create(:job_user_passed_job, job: job) }
  let(:user) { job_user.user }
  let(:frilans_finans_attributes) { {} }
  let(:frilans_api_klass) { FrilansFinansApi::Invoice }
  let(:ff_document_mock) { OpenStruct.new(resource: OpenStruct.new(id: 1)) }
  let(:ff_nil_document_mock) { OpenStruct.new(resource: OpenStruct.new(id: nil)) }
  let(:invoice_request_body) { /^invoice*/ }

  subject do
    FrilansFinansApi.client_klass = FrilansFinansApi::Client

    stub_request(:post, 'https://frilansfinans.se/api/invoices').
      with(body: invoice_request_body,
           headers: { 'User-Agent' => 'FrilansFinansAPI - Ruby client' }).
      to_return(status: 200, body: '{ "data": { "id": "1" } }', headers: {})

    the_subject = described_class.create(
      job_user: job_user,
      frilans_finans_attributes: frilans_finans_attributes
    )
    FrilansFinansApi.reset_config
    the_subject
  end

  it 'creates an invoice' do
    expect { subject }.to change(Invoice, :count).by(1)
  end

  it 'notifies user' do
    allow(InvoiceCreatedNotifier).to receive(:call).
      with(job: job, user: user)
    subject
    expect(InvoiceCreatedNotifier).to have_received(:call)
  end

  it 'calls nil notifier' do
    allow(NilNotifier).to receive(:call)
    subject
    expect(NilNotifier).to have_received(:call)
  end

  context 'no company frilans finans id' do
    let(:company) { FactoryGirl.create(:company, frilans_finans_id: nil) }

    it 'calls missing company frilans finans id notifier' do
      allow(InvoiceMissingCompanyFrilansFinansIdNotifier).to receive(:call)
      subject
      expect(InvoiceMissingCompanyFrilansFinansIdNotifier).to have_received(:call)
    end
  end

  context 'Frilans Finans' do
    it 'creates with a Frilans Finans id' do
      expect(subject.frilans_finans_id).to eq(1)
    end

    it 'calls Frilans Finans API' do
      allow(frilans_api_klass).to receive(:create).and_return(ff_document_mock)
      subject
      expect(frilans_api_klass).to have_received(:create)
    end
  end

  context 'invalid invoice' do
    subject do
      described_class.create(job_user: JobUser.new, frilans_finans_attributes: {})
    end

    it 'does *not* persist invoice' do
      expect(subject.persisted?).to eq(false)
    end
  end

  context 'invalid Frilans Finans API response' do
    let(:job) do
      company = FactoryGirl.create(:company, frilans_finans_id: 1)
      owner = FactoryGirl.create(:user, company: company)
      FactoryGirl.create(:passed_job, owner: owner)
    end

    subject do
      job_user = FactoryGirl.build(:job_user_passed_job, job: job)
      described_class.create(job_user: job_user, frilans_finans_attributes: {})
    end

    it 'does persist invoice' do
      expect(subject.persisted?).to eq(true)
    end

    it 'adds error message' do
      allow(frilans_api_klass).to receive(:create).and_return(ff_nil_document_mock)
      message = I18n.t('errors.invoice.frilans_finans_id')
      expect(subject.errors.messages[:frilans_finans_id]).to include(message)
    end

    it 'does call Frilans Finans API' do
      allow(frilans_api_klass).to receive(:create).and_return(ff_nil_document_mock)
      subject
      expect(frilans_api_klass).to have_received(:create)
    end

    it 'does *not* notify user' do
      allow(frilans_api_klass).to receive(:create).and_return(ff_nil_document_mock)
      allow(InvoiceCreatedNotifier).to receive(:call)
      subject
      expect(InvoiceCreatedNotifier).not_to have_received(:call)
    end
  end
end
