# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmploymentPeriod, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: employment_periods
#
#  id                 :integer          not null, primary key
#  job_id             :integer
#  user_id            :integer
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
