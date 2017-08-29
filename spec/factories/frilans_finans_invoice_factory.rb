# frozen_string_literal: true

FactoryGirl.define do
  factory :frilans_finans_invoice do
    sequence :frilans_finans_id do |n|
      n
    end

    association :job_user, factory: :job_user_will_perform
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
