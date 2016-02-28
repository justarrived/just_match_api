# frozen_string_literal: true
class JobUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :job

  validates :user, presence: true
  validates :job, presence: true

  validate :validate_applicant_not_owner_of_job
  validate :validate_single_applicant, on: :update

  validates :user, uniqueness: { scope: :job }
  validates :job, uniqueness: { scope: :user }

  scope :accepted, -> { where(accepted: true) }

  NOT_OWNER_OF_JOB_ERR_MSG = I18n.t('errors.job_user.not_owner_of_job')
  MULTPLE_APPLICANT_ERR_MSG = I18n.t('errors.job_user.multiple_applicants')

  def self.accepted_jobs_for(user)
    where(user: user, accepted: true).
      includes(:job).
      map(&:job)
  end

  def validate_applicant_not_owner_of_job
    if job && job.owner == user
      errors.add(:user, NOT_OWNER_OF_JOB_ERR_MSG)
    end
  end

  def validate_single_applicant
    if self.class.accepted.find_by(job: job)
      errors.add(:multiple_applicants, MULTPLE_APPLICANT_ERR_MSG)
    end
  end

  # NOTE: You need to call this __before__ the record is saved/updated
  #       otherwise it will always return false
  def send_accepted_notice?
    accepted_changed? && accepted
  end

  def accept
    self.accepted = true
  end
end

# == Schema Information
#
# Table name: job_users
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  job_id     :integer
#  accepted   :boolean          default(FALSE)
#  rate       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
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
