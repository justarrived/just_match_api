# frozen_string_literal: true

FactoryBot.define do
  factory :employment_period do
    job_user nil
    user nil
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
#  id                 :integer          not null, primary key
#  job_user_id        :integer
#  user_id            :integer
#  employer_signed_at :datetime
#  employee_signed_at :datetime
#  started_at         :datetime
#  ended_at           :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_employment_periods_on_job_user_id  (job_user_id)
#  index_employment_periods_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (job_user_id => job_users.id)
#  fk_rails_...  (user_id => users.id)
#
