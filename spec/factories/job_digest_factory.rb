# frozen_string_literal: true

FactoryGirl.define do
  factory :job_digest do
    city 'Stockholm'
    notification_frequency 1
    association :subscriber, factory: :job_digest_subscriber
  end
end

# == Schema Information
#
# Table name: job_digests
#
#  id                       :integer          not null, primary key
#  city                     :string
#  notification_frequency   :integer
#  job_digest_subscriber_id :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
# Indexes
#
#  index_job_digests_on_job_digest_subscriber_id  (job_digest_subscriber_id)
#
# Foreign Keys
#
#  fk_rails_...  (job_digest_subscriber_id => job_digest_subscribers.id)
#
