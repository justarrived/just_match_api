# frozen_string_literal: true

class DigestSubscriberSerializer < ApplicationSerializer
  attributes :email, :uuid

  has_many :job_digests
end

# == Schema Information
#
# Table name: digest_subscribers
#
#  id         :bigint(8)        not null, primary key
#  email      :string
#  uuid       :string(36)
#  deleted_at :datetime
#  user_id    :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_digest_subscribers_on_user_id  (user_id)
#  index_digest_subscribers_on_uuid     (uuid) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
