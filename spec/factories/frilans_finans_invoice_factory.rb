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
#  id                :integer          not null, primary key
#  frilans_finans_id :integer
#  job_user_id       :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_frilans_finans_invoices_on_job_user_id  (job_user_id)
#
# Foreign Keys
#
#  fk_rails_061906fba3  (job_user_id => job_users.id)
#
