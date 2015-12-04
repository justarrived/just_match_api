class Job < ActiveRecord::Base
  has_many :job_skills
  has_many :skills, through: :job_skills

  has_many :job_users
  has_many :users, through: :job_users

  validates :max_rate, numericality: { only_integer: true }, allow_blank: false
  validates :description, length: { minimum: 10 }, allow_blank: false
  # TODO: Validate #job_date ?
end

# == Schema Information
#
# Table name: jobs
#
#  id          :integer          not null, primary key
#  max_rate    :integer
#  description :text
#  job_date    :datetime
#  performed   :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
