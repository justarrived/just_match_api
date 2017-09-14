# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobDigestAddress, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: job_digest_addresses
#
#  id            :integer          not null, primary key
#  job_digest_id :integer
#  address_id    :integer
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
