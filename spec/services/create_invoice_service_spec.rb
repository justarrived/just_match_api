# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CreateInvoiceService, type: :serializer do
  let(:job_user) { FactoryGirl.build(:job_user_passed_job) }
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

    it 'does *not* call Frilans Finans API' do
      allow(frilans_api_klass).to receive(:create)
      subject
      expect(frilans_api_klass).not_to have_received(:create)
    end
  end
end
