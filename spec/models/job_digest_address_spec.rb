# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobDigestAddress, type: :model do
end

# == Schema Information
#
# Table name: job_digest_addresses
#
#  id            :bigint(8)        not null, primary key
#  job_digest_id :bigint(8)
#  address_id    :bigint(8)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_job_digest_addresses_on_address_id     (address_id)
#  index_job_digest_addresses_on_job_digest_id  (job_digest_id)
#
# Foreign Keys
#
#  fk_rails_...  (address_id => addresses.id)
#  fk_rails_...  (job_digest_id => job_digests.id)
#
