# frozen_string_literal: true

class JobDigestSerializer < ApplicationSerializer
  belongs_to :digest_subscriber

  attributes :notification_frequency, :max_distance

  belongs_to :address
end

# == Schema Information
#
# Table name: job_digests
#
#  id                       :integer          not null, primary key
#  address_id               :integer
#  notification_frequency   :integer
#  max_distance             :float
#  locale                   :string(10)
#  digest_subscriber_id :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
# Indexes
#
#  index_job_digests_on_address_id                (address_id)
#  index_job_digests_on_digest_subscriber_id  (digest_subscriber_id)
#
# Foreign Keys
#
#  fk_rails_...  (address_id => addresses.id)
#  fk_rails_...  (digest_subscriber_id => digest_subscribers.id)
#
