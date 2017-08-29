# frozen_string_literal: true

class DigestSubscriber < ApplicationRecord
  belongs_to :user, optional: true

  has_many :job_digests, dependent: :destroy

  before_validation :set_uuid
  before_validation :set_normalized_email

  validates :uuid, presence: true
  validates :email, email: true, uniqueness: true, allow_blank: true

  validate :validates_user_or_email_presence
  validate :validates_user_and_email_both_not_present
  validate :validates_email_not_belong_to_user

  def soft_destroy!
    update!(deleted_at: Time.zone.now)
  end

  def contact_email
    return user.contact_email if user

    email
  end

  def validates_user_or_email_presence
    return if email.present?
    return if user.present?

    errors.add(:user, :blank)
    errors.add(:email, :blank)
  end

  def validates_user_and_email_both_not_present
    return if user.blank?
    return if email.blank?

    errors.add(:user, :present)
    errors.add(:email, :present)
  end

  def validates_email_not_belong_to_user
    return if email.blank?
    return if User.find_by(email: email).blank?

    message = I18n.t('errors.digest_subscriber.email_belongs_to_user_account')
    errors.add(:email, message)
  end

  def set_normalized_email
    self.email = EmailAddress.normalize(email)
  end

  def set_uuid
    return if uuid.present?

    self.uuid = SecureGenerator.uuid
  end
end

# == Schema Information
#
# Table name: digest_subscribers
#
#  id         :integer          not null, primary key
#  email      :string
#  uuid       :string(36)
#  deleted_at :datetime
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_digest_subscribers_on_user_id  (user_id)
#  index_digest_subscribers_on_uuid     (uuid) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
