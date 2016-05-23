# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CreateFrilansFinansInvoiceService do
  before(:each) { stub_frilans_finans_auth_request }

  let(:base_uri) { FrilansFinansApi.base_uri }
  let(:company) { FactoryGirl.create(:company, frilans_finans_id: 1) }
  let(:job) do
    owner = FactoryGirl.create(:user, company: company)
    FactoryGirl.create(:passed_job, owner: owner)
  end
  let(:job_user) { FactoryGirl.create(:job_user_passed_job, job: job, user: user) }
  let(:user) { FactoryGirl.create(:user, frilans_finans_id: 1) }
  let(:ff_invoice) { job_user.frilans_finans_invoice }

  let(:frilans_api_klass) { FrilansFinansApi::Invoice }
  let(:ff_document_mock) { OpenStruct.new(resource: OpenStruct.new(id: 1)) }
  let(:ff_nil_document_mock) { OpenStruct.new(resource: OpenStruct.new(id: nil)) }
  let(:invoice_request_body) { /^\{"invoice":*/ }

  subject do
    isolate_frilans_finans_client(FrilansFinansApi::Client) do
      headers = {
        'Authorization' => 'Bearer xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
        'User-Agent' => 'FrilansFinansAPI - Ruby client',
        'Content-Type' => 'application/json'
      }

      stub_request(:post, "#{base_uri}/invoices").
        with(body: invoice_request_body,
             headers: headers).
        to_return(status: 200, body: '{ "data": { "id": "1" } }', headers: {})

      stub_request(:get, "#{base_uri}/taxes?filter%5Bstandard%5D=1&page=1").
        with(headers: headers).
        to_return(status: 200, body: '{ "data": { "id": "3" } }', headers: {})

      ff_user_body = {
        data: {
          id: '5',
          attributes: {}
        }
      }

      stub_request(:patch, "#{base_uri}/users/1").
        with(headers: headers, body: /^\{"profession_title":"Category /).
        to_return(status: 200, body: JSON.dump(ff_user_body), headers: {})

      described_class.create(ff_invoice: ff_invoice)
    end
  end

  it 'creates an invoice' do
    expect { subject }.to change(FrilansFinansInvoice, :count).by(1)
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

  context 'invalid Frilans Finans API response' do
    let(:job) do
      company = FactoryGirl.create(:company, frilans_finans_id: 1)
      owner = FactoryGirl.create(:user, company: company)
      FactoryGirl.create(:passed_job, owner: owner)
    end

    let(:user) { FactoryGirl.create(:user, frilans_finans_id: 2) }

    subject do
      isolate_frilans_finans_client(FrilansFinansApi::NilClient) do
        described_class.create(ff_invoice: ff_invoice)
      end
    end

    it 'does persist invoice' do
      isolate_frilans_finans_client(FrilansFinansApi::NilClient) do
        expect(subject.persisted?).to eq(true)
      end
    end

    it 'does call Frilans Finans API' do
      isolate_frilans_finans_client(FrilansFinansApi::NilClient) do
        allow(frilans_api_klass).to receive(:create).and_return(ff_nil_document_mock)
        subject
        expect(frilans_api_klass).to have_received(:create)
      end
    end

    it 'notifies admin user' do
      isolate_frilans_finans_client(FrilansFinansApi::NilClient) do
        allow(frilans_api_klass).to receive(:create).and_return(ff_nil_document_mock)
        allow(InvoiceFailedToConnectToFrilansFinansNotifier).to receive(:call)
        subject
        expect(InvoiceFailedToConnectToFrilansFinansNotifier).to have_received(:call)
      end
    end
  end
end
