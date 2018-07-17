# frozen_string_literal: true

FactoryBot.define do
  factory :job_skill do
    association :skill
    association :job

    factory :job_skill_for_docs do
      id 1
      created_at Time.new(2016, 2, 10, 1, 1, 1).utc
      updated_at Time.new(2016, 2, 12, 1, 1, 1).utc
    end
  end
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
#  fk_rails_...  (job_id => jobs.id)
#  fk_rails_...  (skill_id => skills.id)
#
