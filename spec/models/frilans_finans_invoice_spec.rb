# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FrilansFinansInvoice, type: :model do
  describe '#name' do
    it 'returns the correct email' do
      ff_invoice = FactoryGirl.create(:frilans_finans_invoice)
      expect(ff_invoice.name).to eq("##{ff_invoice.id} Frilans Finans Invoice")
    end
  end

  describe '#validates_job_user_will_perform' do
    let(:invalid_job_user) { FactoryGirl.build(:job_user) }
    let(:valid_job_user) { FactoryGirl.build(:job_user_passed_job) }

    it 'adds error if job_user#will_perform is *not* true' do
      ff_invoice = described_class.new(job_user: invalid_job_user)
      ff_invoice.validate

      message = ff_invoice.errors.messages[:job_user_will_perform]
      expect(message).to include(I18n.t('errors.messages.accepted'))
    end

    it 'adds *no* error if job_user#will_perform is true' do
      ff_invoice = described_class.new(job_user: valid_job_user)
      ff_invoice.validate

      message = ff_invoice.errors.messages[:job_user_will_perform] || []
      expect(message).not_to include(I18n.t('errors.messages.accepted'))
    end
  end
end

# == Schema Information
#
# Table name: frilans_finans_invoices
#
#  id                 :integer          not null, primary key
#  frilans_finans_id  :integer
#  job_user_id        :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  activated          :boolean          default(FALSE)
#  ff_pre_report      :boolean          default(TRUE)
#  ff_amount          :float
#  ff_gross_salary    :float
#  ff_net_salary      :float
#  ff_payment_status  :integer
#  ff_approval_status :integer
#  ff_status          :integer
#  ff_sent_at         :datetime
#  express_payment    :boolean          default(FALSE)
#  ff_last_synced_at  :datetime
#
# Indexes
#
#  index_frilans_finans_invoices_on_job_user_id  (job_user_id)
#
# Foreign Keys
#
#  fk_rails_...  (job_user_id => job_users.id)
#
