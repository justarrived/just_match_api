# frozen_string_literal: true

FactoryGirl.define do
  factory :job_digest do
    notification_frequency 1
    association :subscriber, factory: :digest_subscriber
    association :address
    locale I18n.default_locale
    deleted_at nil

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
#  id                     :integer          not null, primary key
#  address_id             :integer
#  notification_frequency :integer
#  max_distance           :float
#  locale                 :string(10)
#  deleted_at             :datetime
#  digest_subscriber_id   :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_job_digests_on_address_id            (address_id)
#  index_job_digests_on_digest_subscriber_id  (digest_subscriber_id)
#
# Foreign Keys
#
#  fk_rails_...  (address_id => addresses.id)
#  fk_rails_...  (digest_subscriber_id => digest_subscribers.id)
#
