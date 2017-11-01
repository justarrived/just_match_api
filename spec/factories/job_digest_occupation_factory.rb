# frozen_string_literal: true

FactoryBot.define do
  factory :job_digest_occupation do
    association :job_digest
    association :occupation

    factory :job_digest_occupation_for_docs do
      id 1
      created_at Time.new(2016, 2, 10, 1, 1, 1).utc
      updated_at Time.new(2016, 2, 12, 1, 1, 1).utc
    end
  end
end

# == Schema Information
#
# Table name: job_digest_occupations
#
#  id            :integer          not null, primary key
#  job_digest_id :integer
#  occupation_id :integer
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
