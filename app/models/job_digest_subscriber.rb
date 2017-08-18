# frozen_string_literal: true

class JobDigestSubscriber < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :job_digest, dependent: :destroy

  before_validation :set_uuid

  validates :uuid, presence: true
  validates :email, email: true

  validate :validates_user_or_email_presence
  validate :validates_user_and_email_both_not_presence

  def validates_user_or_email_presence
    return if email.present?
    return if user.present?

    errors.add(:user, :blank)
    errors.add(:email, :blank)
  end

  def validates_user_and_email_both_not_presence
    return if user.blank?
    return if email.blank?

    errors.add(:user, :present)
    errors.add(:email, :present)
  end

  def set_uuid
    return if uuid.present?

    self.uuid = SecureGenerator.uuid
  end
end

# == Schema Information
#
# Table name: job_digest_subscribers
#
#  id            :integer          not null, primary key
#  email         :string
#  uuid          :string(36)
#  user_id       :integer
#  job_digest_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_job_digest_subscribers_on_job_digest_id  (job_digest_id)
#  index_job_digest_subscribers_on_user_id        (user_id)
#  index_job_digest_subscribers_on_uuid           (uuid) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (job_digest_id => job_digests.id)
#  fk_rails_...  (user_id => users.id)
#
