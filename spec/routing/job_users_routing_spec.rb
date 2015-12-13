require 'rails_helper'

RSpec.describe Api::V1::Jobs::JobUsersController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/jobs/1/users').to route_to('api/v1/jobs/job_users#index', job_id: '1')
    end

    it 'routes to #show' do
      expect(get: '/api/v1/jobs/1/users/1').to route_to('api/v1/jobs/job_users#show', job_id: '1', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/api/v1/jobs/1/users').to route_to('api/v1/jobs/job_users#create', job_id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/api/v1/jobs/1/users/1').to route_to('api/v1/jobs/job_users#destroy', job_id: '1', id: '1')
    end
  end
end
