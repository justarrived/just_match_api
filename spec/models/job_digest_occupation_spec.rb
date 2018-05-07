# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobDigestOccupation, type: :model do
end

# == Schema Information
#
# Table name: job_digest_occupations
#
#  id            :bigint(8)        not null, primary key
#  job_digest_id :bigint(8)
#  occupation_id :bigint(8)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_job_digest_occupations_on_job_digest_id  (job_digest_id)
#  index_job_digest_occupations_on_occupation_id  (occupation_id)
#
# Foreign Keys
#
#  fk_rails_...  (job_digest_id => job_digests.id)
#  fk_rails_...  (occupation_id => occupations.id)
#
