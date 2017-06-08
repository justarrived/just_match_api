# frozen_string_literal: true

FactoryGirl.define do
  factory :arbetsformedlingen_ad do
    association :job
    published false
  end
end

# == Schema Information
#
# Table name: arbetsformedlingen_ads
#
#  id         :integer          not null, primary key
#  job_id     :integer
#  published  :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_arbetsformedlingen_ads_on_job_id  (job_id)
#
# Foreign Keys
#
#  fk_rails_...  (job_id => jobs.id)
#
