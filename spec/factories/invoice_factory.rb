# frozen_string_literal: true
FactoryGirl.define do
  factory :invoice do
    sequence :frilans_finans_id do |n|
      n
    end

    association :job_user, factory: :job_user_passed_job
  end
end

# == Schema Information
#
# Table name: invoices
#
#  id                :integer          not null, primary key
#  frilans_finans_id :integer
#  job_user_id       :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_invoices_on_frilans_finans_id  (frilans_finans_id) UNIQUE
#  index_invoices_on_job_user_id        (job_user_id)
#
# Foreign Keys
#
#  fk_rails_c894e05ce5  (job_user_id => job_users.id)
#
