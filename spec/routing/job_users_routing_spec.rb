require 'rails_helper'

RSpec.describe Api::V1::Jobs::JobUsersController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      path = '/api/v1/jobs/1/users'
      route_path = 'api/v1/jobs/job_users#index'
      expect(get: path).to route_to(route_path, job_id: '1')
    end

    it 'routes to #show' do
      path = '/api/v1/jobs/1/users/1'
      route_path = 'api/v1/jobs/job_users#show'
      expect(get: path).to route_to(route_path, job_id: '1', id: '1')
    end

    it 'routes to #create' do
      path = '/api/v1/jobs/1/users'
      route_path = 'api/v1/jobs/job_users#create'
      expect(post: path).to route_to(route_path, job_id: '1')
    end

    it 'routes to #destroy' do
      path = '/api/v1/jobs/1/users/1'
      route_path = 'api/v1/jobs/job_users#destroy'
      expect(delete: path).to route_to(route_path, job_id: '1', id: '1')
    end
  end
end
