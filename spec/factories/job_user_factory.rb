# frozen_string_literal: true
FactoryGirl.define do
  factory :job_user do
    association :user
    association :job

    accepted false
    will_perform false

    factory :job_user_concluded do
      accepted true
      will_perform true
      performed_accepted true
    end

    factory :job_user_accepted do
      accepted true
    end

    factory :job_user_will_perform do
      accepted true
      will_perform true
    end

    factory :job_user_for_docs do
      id 1
      created_at Time.new(2016, 02, 10, 1, 1, 1).utc
      updated_at Time.new(2016, 02, 12, 1, 1, 1).utc
    end
  end
end

# == Schema Information
#
# Table name: job_users
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  job_id             :integer
#  accepted           :boolean          default(FALSE)
#  rate               :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  will_perform       :boolean          default(FALSE)
#  accepted_at        :datetime
#  performed          :boolean          default(FALSE)
#  performed_accepted :boolean          default(FALSE)
#
# Indexes
#
#  index_job_users_on_job_id              (job_id)
#  index_job_users_on_job_id_and_user_id  (job_id,user_id) UNIQUE
#  index_job_users_on_user_id             (user_id)
#  index_job_users_on_user_id_and_job_id  (user_id,job_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_548d2d3ba9  (job_id => jobs.id)
#  fk_rails_815844930e  (user_id => users.id)
#
