# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Jobs::JobDigestsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      path = '/api/v1/digests/subscribers/1/jobs'
      route_path = 'api/v1/jobs/digests/job_digests#index'
      expect(patch: path).to route_to(route_path, job_digest_subscriber_id: '1')
    end

    it 'routes to #create' do
      path = '/api/v1/jobs/digests'
      route_path = 'api/v1/jobs/job_digests#create'
      expect(post: path).to route_to(route_path)
    end

    it 'routes to #update' do
      path = '/api/v1/jobs/digests/1'
      route_path = 'api/v1/jobs/job_digests#update'
      expect(patch: path).to route_to(route_path, job_digest_id: '1')
    end

    it 'routes to #destroy' do
      path = '/api/v1/jobs/digests/uuid'
      route_path = 'api/v1/jobs/job_digests#destroy'
      expect(delete: path).to route_to(route_path, job_digest_id: 'uuid')
    end
  end
end
