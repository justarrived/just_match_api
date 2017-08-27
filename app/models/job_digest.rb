# frozen_string_literal: true

class JobDigest < ApplicationRecord
  NOTIFICATION_FREQUENCY = {
    daily: 1,
    weekly: 2
  }.freeze

  belongs_to :subscriber, class_name: 'JobDigestSubscriber', foreign_key: 'job_digest_subscriber_id' # rubocop:disable Metrics/LineLength
  belongs_to :address, optional: true

  has_one :user, through: :subscriber

  has_many :job_digest_occupations, dependent: :destroy
  has_many :occupations, through: :job_digest_occupations

  validates :notification_frequency, presence: true

  enum notification_frequency: NOTIFICATION_FREQUENCY

  def email
    subscriber.contact_email
  end
end

# == Schema Information
#
# Table name: job_digests
#
#  id                       :integer          not null, primary key
#  city                     :string
#  notification_frequency   :integer
#  job_digest_subscriber_id :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
# Indexes
#
#  index_job_digests_on_job_digest_subscriber_id  (job_digest_subscriber_id)
#
# Foreign Keys
#
#  fk_rails_...  (job_digest_subscriber_id => job_digest_subscribers.id)
#
