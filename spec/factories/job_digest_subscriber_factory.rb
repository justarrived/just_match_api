# frozen_string_literal: true

FactoryGirl.define do
  factory :job_digest_subscriber do
    sequence :email do |n|
      "subscriber#{n}@example.com"
    end
    user nil

    factory :job_digest_subscriber_for_docs do
      id 1
      sequence :email do |n|
        "example-subscriber#{n}@example.com"
      end
      created_at Time.new(2016, 2, 10, 1, 1, 1).utc
      updated_at Time.new(2016, 2, 12, 1, 1, 1).utc
    end
  end
end

# == Schema Information
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
