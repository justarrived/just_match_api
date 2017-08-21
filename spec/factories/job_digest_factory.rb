# frozen_string_literal: true

FactoryGirl.define do
  factory :job_digest do
    city 'Stockholm'
    notification_frequency 1
    association :subscriber, factory: :job_digest_subscriber

    factory :job_digest_for_docs do
      id 1
      notification_frequency 1
      city 'Stockholm'
      subscriber nil
      created_at Time.new(2016, 2, 10, 1, 1, 1).utc
      updated_at Time.new(2016, 2, 12, 1, 1, 1).utc
    end
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