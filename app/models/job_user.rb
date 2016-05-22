# frozen_string_literal: true
class JobUser < ApplicationRecord
  MAX_CONFIRMATION_TIME_HOURS = 18

  belongs_to :user
  belongs_to :job

  has_one :invoice
  has_one :frilans_finans_invoice

  validates :user, presence: true
  validates :job, presence: true

  validates :user, uniqueness: { scope: :job }
  validates :job, uniqueness: { scope: :user }

  validates :will_perform, after_true: { field: :accepted }, if: :will_perform
  validates :performed, after_true: { field: :will_perform }, if: :performed

  validates :accepted, unrevertable: true, unless: :applicant_confirmation_overdue?
  validates :will_perform, unrevertable: true
  validates :performed, unrevertable: true

  validate :validate_single_applicant, on: :update
  validate :validate_applicant_not_owner_of_job
  validate :validate_job_started_before_performed

  before_validation :accepted_at_setter

  scope :accepted, -> { where(accepted: true) }
  scope :will_perform, -> { where(will_perform: true) }
  scope :unconfirmed, -> { accepted.where(will_perform: false) }
  scope :applicant_confirmation_overdue, lambda {
    unconfirmed.where('accepted_at < ?', MAX_CONFIRMATION_TIME_HOURS.hours.ago)
  }

  def self.accepted_jobs_for(user)
    where(user: user, accepted: true).
      includes(:job).
      map(&:job)
  end

  def applicant_confirmation_overdue?
    return false if accepted_at.nil? || will_perform

    accepted_at < MAX_CONFIRMATION_TIME_HOURS.hours.ago
  end

  def will_perform_confirmation_by
    return if accepted_at.nil?

    accepted_at + MAX_CONFIRMATION_TIME_HOURS.hours
  end

  def validate_applicant_not_owner_of_job
    if job && job.owner == user
      message = I18n.t('errors.job_user.not_owner_of_job')
      errors.add(:user, message)
    end
  end

  def validate_single_applicant
    accepted_user = self.class.accepted.find_by(job: job).try!(:user)
    if accepted_user && user != accepted_user
      message = I18n.t('errors.job_user.multiple_applicants')
      errors.add(:multiple_applicants, message)
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

  def concluded?
    !invoice.nil?
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

  # NOTE: You need to call this __before__ the record is validated
  #       otherwise it will always return false
  def send_performed_notice?
    performed_changed? && performed
  end

  def validate_job_started_before_performed
    return if job && job.started?
    return unless performed

    message = I18n.t('errors.job_user.performed_before_job_started')
    errors.add(:performed, message)
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
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  will_perform :boolean          default(FALSE)
#  accepted_at  :datetime
#  performed    :boolean          default(FALSE)
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
