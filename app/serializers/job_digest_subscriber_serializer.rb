# frozen_string_literal: true

class JobDigestSubscriberSerializer < ApplicationSerializer
  attributes :email, :uuid

  has_many :job_digests
end

# == Schema Information/
#
# Table name: job_digest_subscribers
#
#  id         :integer          not null, primary key
#  email      :string
#  uuid       :string(36)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_job_digest_subscribers_on_user_id  (user_id)
#  index_job_digest_subscribers_on_uuid     (uuid) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
