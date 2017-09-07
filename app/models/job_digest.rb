# frozen_string_literal: true

class JobDigest < ApplicationRecord
  NOTIFICATION_FREQUENCY = {
    daily: 1,
    weekly: 2
  }.freeze

  DEFAULT_MAX_DISTANCE = 50

  before_validation :set_max_distance
  before_validation :set_locale

  belongs_to :subscriber, class_name: 'DigestSubscriber', foreign_key: 'digest_subscriber_id' # rubocop:disable Metrics/LineLength
  belongs_to :address, optional: true

  has_one :user, through: :subscriber

  has_many :job_digest_occupations, dependent: :destroy
  has_many :occupations, through: :job_digest_occupations

  validates :notification_frequency, presence: true
  validates :max_distance, numericality: { greater_than_or_equal_to: 0 }, presence: true

  validate :validate_subscriber_valid

  enum notification_frequency: NOTIFICATION_FREQUENCY

  scope :active, -> { where(deleted_at: nil) }

  def validate_subscriber_valid
    return if subscriber.nil?
    return if subscriber.persisted?
    return if subscriber.valid?

    errors.add(:subscriber, :invalid)
  end

  def soft_destroy!
    update!(deleted_at: Time.zone.now)
  end

  def coordinates?
    return false unless address

    address.coordinates?
  end

  def email
    subscriber.contact_email
  end

  def set_locale
    self.locale = locale.presence || user&.locale.presence || I18n.default_locale.to_s
  end

  def set_max_distance
    return if max_distance.present?

    self.max_distance = DEFAULT_MAX_DISTANCE
  end
end

# == Schema Information
#
# Table name: job_digests
#
#  id                     :integer          not null, primary key
#  address_id             :integer
#  notification_frequency :integer
#  max_distance           :float
#  locale                 :string(10)
#  deleted_at             :datetime
#  digest_subscriber_id   :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_job_digests_on_address_id            (address_id)
#  index_job_digests_on_digest_subscriber_id  (digest_subscriber_id)
#
# Foreign Keys
#
#  fk_rails_...  (address_id => addresses.id)
#  fk_rails_...  (digest_subscriber_id => digest_subscribers.id)
#
