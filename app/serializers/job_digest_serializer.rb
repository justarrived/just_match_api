# frozen_string_literal: true

class JobDigestSerializer < ApplicationSerializer
  has_one :job_digest_subscriber

  attributes :notification_frequency, :city
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
