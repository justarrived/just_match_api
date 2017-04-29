# frozen_string_literal: true
require 'rails_helper'

RSpec.describe FrilansFinans::InvoiceWrapper do
  describe '#attributes' do
    it 'returns the invoice data schema' do
      allow(described_class).to receive(:invoice_users).and_return({})
      allow(described_class).to receive(:invoice_dates).and_return({})
      allow(described_class).to receive(:invoice_data).and_return(a: 1)

      result = described_class.attributes(
        job: nil,
        user: nil,
        tax: nil,
        ff_user: nil,
        pre_report: false,
        express_payment: false
      )

      expected = {
        a: 1,
        invoicedate: {},
        invoiceuser: {}
      }
      expect(result).to eq(expected)
    end
  end

  describe '#invoice_data' do
    let(:ff_user_id) { 10 }
    let(:ff_company_id) { 11 }
    let(:ff_tax_id) { '3' }
    let(:company) { FactoryGirl.create(:company, frilans_finans_id: ff_company_id) }
    let(:owner) { FactoryGirl.create(:user, company: company) }
    let(:job) { FactoryGirl.create(:job, job_end_date: 2.weeks.from_now, owner: owner, hours: 50) }
    let(:tax) { Struct.new(:id).new(ff_tax_id) }
    let(:user) { FactoryGirl.build(:user, frilans_finans_id: ff_user_id) }
    let(:invoice_data) do
      described_class.invoice_data(
        job: job,
        user: user,
        tax: tax,
        pre_report: true
      )
    end

    it 'returns the main invoice data' do
      expected = {
        currency_id: Currency.default_currency&.frilans_finans_id,
        specification: job.invoice_specification,
        amount: job.invoice_amount,
        company_id: ff_company_id,
        tax_id: ff_tax_id,
        user_id: ff_user_id,
        pre_report: true
      }

      expect(invoice_data).to eq(expected)
    end

    it 'calculates amount based on gross salary' do
      expected_amount = job.hourly_pay.rate_excluding_vat * job.hours
      expect(invoice_data[:amount]).to eq(expected_amount)
    end
  end

  describe '#invoice_users' do
    let(:user) { FactoryGirl.build(:user) }
    let(:job) { FactoryGirl.build(:job, hours: 50) }
    let(:taxkey_id) { 13 }
    let(:express_payment) { false }
    let(:invoice_users_result) do
      attributes_mock = Struct.new(:attributes).new('default_taxkey_id' => taxkey_id)
      ff_user_mock = Struct.new(:resource).new(attributes_mock)

      described_class.invoice_users(
        job: job,
        user: user,
        ff_user: ff_user_mock,
        express_payment: express_payment
      )
    end

    it 'returns invoice users data' do
      expected = [{
        user_id: user.frilans_finans_id,
        total: 7000.0,
        taxkey_id: taxkey_id,
        save_vacation_pay: false,
        save_itp: false,
        express_payment: false
      }]

      expect(invoice_users_result).to eq(expected)
    end

    context 'with express payment' do
      let(:express_payment) { true }

      it 'returns invoice users data' do
        expected = [{
          user_id: user.frilans_finans_id,
          total: 7000.0,
          taxkey_id: taxkey_id,
          save_vacation_pay: false,
          save_itp: false,
          express_payment: true
        }]

        expect(invoice_users_result).to eq(expected)
      end
    end
  end

  describe '#invoice_dates' do
    it 'returns invoice dates data' do
      start = Date.new(2016, 4, 22)
      finish = Date.new(2016, 4, 26)
      job = FactoryGirl.build(:job, job_date: start, job_end_date: finish, hours: 50)

      expected = [
        { date: Date.new(2016, 4, 22), hours: 10.0 },
        { date: Date.new(2016, 4, 23), hours: 10.0 },
        { date: Date.new(2016, 4, 24), hours: 10.0 },
        { date: Date.new(2016, 4, 25), hours: 10.0 },
        { date: Date.new(2016, 4, 26), hours: 10.0 }
      ]
      result = described_class.invoice_dates(job: job)

      expect(result).to eq(expected)
    end
  end
end
