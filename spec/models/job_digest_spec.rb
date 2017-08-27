# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobDigest, type: :model do
end

# == Schema Information
#
# Table name: job_digests
#
#  id                       :integer          not null, primary key
#  address_id               :integer
#  notification_frequency   :integer
#  job_digest_subscriber_id :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
# Indexes
#
#  index_job_digests_on_address_id                (address_id)
#  index_job_digests_on_job_digest_subscriber_id  (job_digest_subscriber_id)
#
# Foreign Keys
#
#  fk_rails_...  (address_id => addresses.id)
#  fk_rails_...  (job_digest_subscriber_id => job_digest_subscribers.id)
#
