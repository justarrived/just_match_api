# frozen_string_literal: true

class JobDigest < ApplicationRecord
  NOTIFICATION_FREQUENCY = {
    daily: 1,
    weekly: 2
  }.freeze

  has_many :job_digest_occupations
  has_many :occupations, through: :job_digest_occupations

  has_one :job_digest_subscriber

  validates :notification_frequency, presence: true

  enum notification_frequency: NOTIFICATION_FREQUENCY
end

# == Schema Information
#
# Table name: job_digests
#
#  id                     :integer          not null, primary key
#  city                   :string
#  notification_frequency :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
