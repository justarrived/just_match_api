# frozen_string_literal: true

FactoryBot.define do
  factory :job_digest_address do
    association :job_digest
    association :address
  end
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
