class JobSkill < ActiveRecord::Base
  belongs_to :job
  belongs_to :skill
end

# == Schema Information
#
# Table name: job_skills
#
#  id         :integer          not null, primary key
#  job_id     :integer
#  skill_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_job_skills_on_job_id    (job_id)
#  index_job_skills_on_skill_id  (skill_id)
#
