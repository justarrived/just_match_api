# frozen_string_literal: true

class EmploymentPeriod < ApplicationRecord
  belongs_to :job, optional: true
  belongs_to :user

  validates :started_at, presence: true
  validates :percentage, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  validate :validate_ended_after_started

  def ongoing?
    return false if started_at > Time.current
    return true unless ended_at
    return false if ended_at < Time.current

    true
  end

  def validate_ended_after_started
    return unless started_at
    return unless ended_at
    return if ended_at >= started_at

    errors.add(:ended_at, 'must be after start date')
  end
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
