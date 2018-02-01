# frozen_string_literal: true

class EmploymentPeriod < ApplicationRecord
  belongs_to :job_user, optional: true
  belongs_to :user, optional: true
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
