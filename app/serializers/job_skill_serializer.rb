# frozen_string_literal: true

class JobSkillSerializer < ApplicationSerializer
  has_one :job
  has_one :skill
end

# == Schema Information
#
# Table name: job_skills
#
#  id                   :integer          not null, primary key
#  job_id               :integer
#  skill_id             :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  proficiency          :integer
#  proficiency_by_admin :integer
#
# Indexes
#
#  index_job_skills_on_job_id               (job_id)
#  index_job_skills_on_job_id_and_skill_id  (job_id,skill_id) UNIQUE
#  index_job_skills_on_skill_id             (skill_id)
#  index_job_skills_on_skill_id_and_job_id  (skill_id,job_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_514cd69e1b  (skill_id => skills.id)
#  fk_rails_94b0ff3621  (job_id => jobs.id)
#
