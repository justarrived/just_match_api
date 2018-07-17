# frozen_string_literal: true

FactoryBot.define do
  factory :employment_period do
    job nil
    association :user
    percentage 50.0
    employer_signed_at '2018-02-01 20:58:53'
    employee_signed_at '2018-02-01 20:58:53'
    started_at '2018-02-01 20:58:53'
    ended_at '2018-02-01 20:58:53'
  end
end

# == Schema Information
#
# Table name: employment_periods
#
#  id                 :bigint(8)        not null, primary key
#  job_id             :bigint(8)
#  user_id            :bigint(8)
#  employer_signed_at :datetime
#  employee_signed_at :datetime
#  started_at         :datetime
#  ended_at           :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  percentage         :decimal(, )
#
# Indexes
#
#  index_employment_periods_on_job_id   (job_id)
#  index_employment_periods_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (job_id => jobs.id)
#  fk_rails_...  (user_id => users.id)
#
