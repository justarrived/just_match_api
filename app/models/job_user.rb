class JobUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :job

  validates :user, presence: true
  validates :job, presence: true

  validate :applicant_not_owner_of_job
  validates :user, uniqueness: { scope: :job }
  validates :job, uniqueness: { scope: :user }

  NOT_OWNER_OF_JOB_ERR_MSG = I18n.t('errors.job_user.not_owner_of_job')

  def applicant_not_owner_of_job
    if job && job.owner == user
      errors.add(:user, NOT_OWNER_OF_JOB_ERR_MSG)
    end
  end

  # NOTE: You need to call this __before__ the record is saved/updated
  #       otherwise it will always return false
  def send_accepted_notice?
    accepted_changed? && accepted
  end

  def accept!
    self.accepted = true
    save!
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
#  index_job_users_on_job_id   (job_id)
#  index_job_users_on_user_id  (user_id)
#
