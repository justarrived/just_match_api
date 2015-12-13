require 'rails_helper'

RSpec.describe Api::V1::Jobs::JobSkillsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/jobs/1/skills').to route_to('api/v1/jobs/job_skills#index', job_id: '1')
    end

    it 'routes to #show' do
      expect(get: '/api/v1/jobs/1/skills/1').to route_to('api/v1/jobs/job_skills#show', job_id: '1', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/api/v1/jobs/1/skills').to route_to('api/v1/jobs/job_skills#create', job_id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/api/v1/jobs/1/skills/1').to route_to('api/v1/jobs/job_skills#destroy', job_id: '1', id: '1')
    end
  end
end
