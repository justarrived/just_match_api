require 'rails_helper'

RSpec.describe Api::V1::JobsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/jobs').to route_to('api/v1/jobs#index')
    end

    it 'routes to #show' do
      expect(get: '/api/v1/jobs/1').to route_to('api/v1/jobs#show', job_id: '1')
    end

    it 'routes to #create' do
      expect(post: '/api/v1/jobs').to route_to('api/v1/jobs#create')
    end

    it 'routes to #update via PUT' do
      path = '/api/v1/jobs/1'
      expect(put: path).to route_to('api/v1/jobs#update', job_id: '1')
    end

    it 'routes to #update via PATCH' do
      path = '/api/v1/jobs/1'
      expect(patch: path).to route_to('api/v1/jobs#update', job_id: '1')
    end
  end
end
