# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Digests::JobDigestsController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      path = '/api/v1/digests/jobs'
      route_path = 'api/v1/digests/job_digests#create'
      expect(post: path).to route_to(route_path)
    end

    it 'routes to #update' do
      path = '/api/v1/digests/jobs/1'
      route_path = 'api/v1/digests/job_digests#update'
      expect(patch: path).to route_to(route_path, job_digest_id: '1')
    end

    it 'routes to #update' do
      path = '/api/v1/digests/jobs/uuid'
      route_path = 'api/v1/digests/job_digests#destroy'
      expect(delete: path).to route_to(route_path, job_digest_id: 'uuid')
    end
  end
end
