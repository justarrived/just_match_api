require 'rails_helper'

RSpec.describe Api::V1::Jobs::JobSkillsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      path = '/api/v1/jobs/1/skills'
      route_path = 'api/v1/jobs/job_skills#index'
      expect(get: path).to route_to(route_path, job_id: '1')
    end

    it 'routes to #show' do
      path = '/api/v1/jobs/1/skills/1'
      route_path = 'api/v1/jobs/job_skills#show'
      expect(get: path).to route_to(route_path, job_id: '1', id: '1')
    end

    it 'routes to #create' do
      path = '/api/v1/jobs/1/skills'
      route_path = 'api/v1/jobs/job_skills#create'
      expect(post: path).to route_to(route_path, job_id: '1')
    end

    it 'routes to #destroy' do
      path = '/api/v1/jobs/1/skills/1'
      route_path = 'api/v1/jobs/job_skills#destroy'
      expect(delete: path).to route_to(route_path, job_id: '1', id: '1')
    end
  end
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
# Foreign Keys
#
#  fk_rails_514cd69e1b  (skill_id => skills.id)
#  fk_rails_94b0ff3621  (job_id => jobs.id)
#
