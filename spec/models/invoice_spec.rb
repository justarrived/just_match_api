# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe '#name' do
    let(:invoice) { Invoice.new }

    it 'returns name' do
      expect(invoice.name).to eq('Invoice #')
    end
  end

  describe '#validate_job_started' do
    let(:passed_job) { FactoryGirl.build(:passed_job) }
    let(:inprogress_job) { FactoryGirl.build(:inprogress_job) }
    let(:future_job) { FactoryGirl.build(:future_job) }
    let(:message) { I18n.t('errors.invoice.job_started') }

    it 'adds error if the job is in the future' do
      job_user = FactoryGirl.build(:job_user, job: future_job)
      invoice = FactoryGirl.build(:invoice, job_user: job_user)
      invoice.validate

      expect(invoice.errors.messages[:job]).to include(message)
    end

    it 'adds *no* error if the job is in progress' do
      job_user = FactoryGirl.build(:job_user, job: inprogress_job)
      invoice = FactoryGirl.build(:invoice, job_user: job_user)
      invoice.validate
      expect(invoice.errors.messages[:job] || []).not_to include(message)
    end

    it 'adds *no* error if the job is over' do
      job_user = FactoryGirl.build(:job_user, job: passed_job)
      invoice = FactoryGirl.build(:invoice, job_user: job_user)
      invoice.validate
      expect(invoice.errors.messages[:job] || []).not_to include(message)
    end
  end

  describe '#validate_job_user_accepted' do
    let(:passed_job) { FactoryGirl.build(:passed_job) }
    let(:message) { I18n.t('errors.invoice.job_user_accepted') }

    it 'adds error if the job user is not accepted' do
      job_user = FactoryGirl.build(:job_user, job: passed_job, accepted: false)
      invoice = FactoryGirl.build(:invoice, job_user: job_user)
      invoice.validate

      expect(invoice.errors.messages[:job_user]).to include(message)
    end

    it 'adds *no* error if the job user is accepted' do
      job_user = FactoryGirl.build(:job_user, job: passed_job, accepted: true)
      invoice = FactoryGirl.build(:invoice, job_user: job_user)
      invoice.validate
      expect(invoice.errors.messages[:job_user] || []).not_to include(message)
    end
  end

  describe '#validate_job_user_will_perform' do
  end
end

# == Schema Information
#
# Table name: invoices
#
#  id                        :integer          not null, primary key
#  job_user_id               :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  frilans_finans_invoice_id :integer
#
# Indexes
#
#  index_invoices_on_frilans_finans_invoice_id  (frilans_finans_invoice_id)
#  index_invoices_on_job_user_id                (job_user_id)
#  index_invoices_on_job_user_id_uniq           (job_user_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_bb8882afb5  (frilans_finans_invoice_id => frilans_finans_invoices.id)
#  fk_rails_c894e05ce5  (job_user_id => job_users.id)
#
