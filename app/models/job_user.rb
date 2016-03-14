# frozen_string_literal: true
class JobUser < ActiveRecord::Base
  MAX_CONFIRMATION_TIME_HOURS = 18

  belongs_to :user
  belongs_to :job

  validates :user, presence: true
  validates :job, presence: true

  validate :validate_applicant_not_owner_of_job
  validate :validate_single_applicant, on: :update

  validates :user, uniqueness: { scope: :job }
  validates :job, uniqueness: { scope: :user }

  validate :validate_accepted_not_reverted, unless: :applicant_confirmation_overdue?
  validate :validate_will_perform_not_reverted
  validate :validate_accepted_before_will_perform

  before_validation :accepted_at_setter

  scope :accepted, -> { where(accepted: true) }
  scope :will_perform, -> { where(will_perform: true) }
  scope :unconfirmed, -> { accepted.where(will_perform: false) }
  scope :applicant_confirmation_overdue, lambda {
    where('accepted_at < ?', MAX_CONFIRMATION_TIME_HOURS.hours.ago)
  }

  NOT_OWNER_OF_JOB_ERR_MSG = I18n.t('errors.job_user.not_owner_of_job')
  MULTPLE_APPLICANT_ERR_MSG = I18n.t('errors.job_user.multiple_applicants')
  ACCEPTED_REVERTED_ERR_MSG = I18n.t('errors.job_user.accepted_changed_to_false')
  WILL_PERFORM_REVERTED_ERR_MSG = I18n.t('errors.job_user.will_perform_changed_to_false')
  WILL_PERFORM_ACCEPTED_ERR_MSG = I18n.t('errors.job_user.will_perform_accepted')

  def self.accepted_jobs_for(user)
    where(user: user, accepted: true).
      includes(:job).
      map(&:job)
  end

  def applicant_confirmation_overdue?
    return false if accepted_at.nil?

    accepted_at < MAX_CONFIRMATION_TIME_HOURS.hours.ago
  end

  def validate_applicant_not_owner_of_job
    if job && job.owner == user
      errors.add(:user, NOT_OWNER_OF_JOB_ERR_MSG)
    end
  end

  def validate_single_applicant
    accepted_user = self.class.accepted.find_by(job: job).try!(:user)
    if accepted_user && user != accepted_user
      errors.add(:multiple_applicants, MULTPLE_APPLICANT_ERR_MSG)
    end
  end

  def accept
    self.accepted = true
  end

  def accepted_at_setter
    if accepted_changed? && accepted
      self.accepted_at = Time.zone.now
    end
  end

  # NOTE: You need to call this __before__ the record is validated
  #       otherwise it will always return false
  def send_accepted_notice?
    accepted_changed? && accepted
  end

  # NOTE: You need to call this __before__ the record is validated
  #       otherwise it will always return false
  def send_will_perform_notice?
    will_perform_changed? && will_perform
  end

  def validate_accepted_not_reverted
    return unless accepted_changed? && accepted == false

    errors.add(:accepted, ACCEPTED_REVERTED_ERR_MSG)
  end

  def validate_will_perform_not_reverted
    return unless will_perform_changed? && will_perform == false

    errors.add(:will_perform, WILL_PERFORM_REVERTED_ERR_MSG)
  end

  def validate_accepted_before_will_perform
    return unless will_perform

    unless accepted
      errors.add(:will_perform, WILL_PERFORM_ACCEPTED_ERR_MSG)
    end
  end
end

# == Schema Information
#
# Table name: job_users
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  job_id       :integer
#  accepted     :boolean          default(FALSE)
#  rate         :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  will_perform :boolean          default(FALSE)
#  accepted_at  :datetime
#
# Indexes
#
#  index_job_users_on_job_id              (job_id)
#  index_job_users_on_job_id_and_user_id  (job_id,user_id) UNIQUE
#  index_job_users_on_user_id             (user_id)
#  index_job_users_on_user_id_and_job_id  (user_id,job_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_548d2d3ba9  (job_id => jobs.id)
#  fk_rails_815844930e  (user_id => users.id)
#
