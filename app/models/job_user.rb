# frozen_string_literal: true
class JobUser < ApplicationRecord
  MAX_CONFIRMATION_TIME_HOURS = 18

  belongs_to :user
  belongs_to :job
  belongs_to :language, optional: true

  has_one :company_contact, through: :job
  has_one :owner, through: :job
  has_one :company, through: :job
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

  validate :validate_single_accepted_applicant
  validate :validate_applicant_not_owner_of_job
  validate :validate_job_started_before_performed
  validate :validate_language_presence_if_apply_message

  before_validation :accepted_at_setter

  scope :accepted, -> { where(accepted: true) }
  scope :will_perform, -> { where(will_perform: true) }
  scope :unconfirmed, -> { accepted.where(will_perform: false) }
  scope :performed, -> { where(performed: false) }
  scope :applicant_confirmation_overdue, lambda {
    unconfirmed.where('accepted_at < ?', MAX_CONFIRMATION_TIME_HOURS.hours.ago)
  }
  scope :verified, -> { joins(:user).where('users.verified = ?', true) }

  include Translatable
  translates :apply_message

  def self.accepted_jobs_for(user)
    where(user: user, accepted: true).
      includes(:job).
      map(&:job)
  end

  def name
    "##{id} Job User"
  end

  def current_status
    if job.ended?
      return 'Rejected' unless will_perform

      ff_status = frilans_finans_invoice&.ff_payment_status_name
      return ff_status if ff_status

      return 'Not pre-reported!'
    end

    return 'Will perform' if will_perform
    return 'Accepted' if accepted

    asd

    'Applied'
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

  def validate_single_accepted_applicant
    accepted_user = self.class.accepted.find_by(job: job)&.user
    return if accepted_user.nil?
    return if user == accepted_user
    return unless accepted

    message = I18n.t('errors.job_user.multiple_applicants')
    errors.add(:accepted, message)
  end

  def accept
    self.accepted = true
  end

  def accepted_at_setter
    if accepted_changed? && accepted
      self.accepted_at = Time.zone.now
    end
  end

  def invoiced?
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

  def validate_language_presence_if_apply_message
    # NOTE: apply_message might be fetched from the translations relationship causing
    #       a SQL-query
    return if apply_message.blank?
    return unless language.nil?

    field = self.class.human_attribute_name(:apply_message)
    message = I18n.t('errors.general.blank_if_field', field: field)
    errors.add(:language, message)
  end
end

# == Schema Information
#
# Table name: job_users
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  job_id        :integer
#  accepted      :boolean          default(FALSE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  will_perform  :boolean          default(FALSE)
#  accepted_at   :datetime
#  performed     :boolean          default(FALSE)
#  apply_message :text
#  language_id   :integer
#
# Indexes
#
#  index_job_users_on_job_id              (job_id)
#  index_job_users_on_job_id_and_user_id  (job_id,user_id) UNIQUE
#  index_job_users_on_language_id         (language_id)
#  index_job_users_on_user_id             (user_id)
#  index_job_users_on_user_id_and_job_id  (user_id,job_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_548d2d3ba9  (job_id => jobs.id)
#  fk_rails_815844930e  (user_id => users.id)
#  fk_rails_93547d43e9  (language_id => languages.id)
#
