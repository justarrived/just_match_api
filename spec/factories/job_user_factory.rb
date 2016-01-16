FactoryGirl.define do
  factory :job_user do
    association :user
    association :job
  end
end

# == Schema Information
#
# Table name: job_users
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  job_id     :integer
#  accepted   :boolean          default(FALSE)
#  rate       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_job_users_on_job_id   (job_id)
#  index_job_users_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_548d2d3ba9  (job_id => jobs.id)
#  fk_rails_815844930e  (user_id => users.id)
#
