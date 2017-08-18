# frozen_string_literal: true

FactoryGirl.define do
  factory :job_digest do
    city 'MyString'
    notification_frequency 1
  end
end

# == Schema Information
#
# Table name: job_digests
#
#  id                     :integer          not null, primary key
#  city                   :string
#  notification_frequency :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
