class JobUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :job
end

# == Schema Information
#
# Table name: job_users
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  job_id     :integer
#  accepted   :boolean
#  role       :integer
#  rate       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_job_users_on_job_id   (job_id)
#  index_job_users_on_user_id  (user_id)
#
