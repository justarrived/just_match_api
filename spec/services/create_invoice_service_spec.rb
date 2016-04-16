# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CreateInvoiceService, type: :serializer do
  let(:job_user) { FactoryGirl.create(:job_user_passed_job) }
  let(:user) { job_user.user }
  let(:job) { job_user.job }
  let(:frilans_finans_attributes) { {} }
  let(:frilans_api_klass) { FrilansFinansApi::Invoice }
  let(:ff_document_mock) { OpenStruct.new(resource: OpenStruct.new(id: 1)) }

  subject do
    FrilansFinansApi.client_klass = FrilansFinansApi::Client

    stub_request(:post, 'https://frilansfinans.se/api/invoices').
      with(body: 'grant_type=&client_id=&client_secret=',
           headers: { 'User-Agent' => 'FrilansFinansAPI - Ruby client' }).
      to_return(status: 200, body: '{ "data": { "id": "1" } }', headers: {})

    described_class.create(
      job_user: job_user,
      frilans_finans_attributes: frilans_finans_attributes
    ).tap do
      FrilansFinansApi.reset_config
    end
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

  context 'Frilans Finans' do
    it 'creates with a Frialans Finans id' do
      expect(subject.frilans_finans_id).to eq(1)
    end

    it 'calls Frilans Finans API' do
      allow(frilans_api_klass).to receive(:create).and_return(ff_document_mock)
      subject
      expect(frilans_api_klass).to have_received(:create)
    end
  end

  context 'invalid' do
    subject do
      described_class.create(job_user: JobUser.new, frilans_finans_attributes: {})
    end

    it 'does *not* persist invoice' do
      expect(subject.persisted?).to eq(false)
    end

    it 'adds error message' do
      message = I18n.t('errors.invoice.frilans_finans_id')
      expect(subject.errors.messages[:frilans_finans_id]).to include(message)
    end

    it 'does *not* call Frilans Finans API' do
      allow(frilans_api_klass).to receive(:create)
      subject
      expect(frilans_api_klass).not_to have_received(:create)
    end

    it 'does *not* notify user' do
      allow(InvoiceCreatedNotifier).to receive(:call).
        with(job: job, user: user)
      subject
      expect(InvoiceCreatedNotifier).not_to have_received(:call)
    end
  end
end
