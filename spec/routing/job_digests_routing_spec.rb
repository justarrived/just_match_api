# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::JobDigestsController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      path = '/api/v1/job-digests/'
      route_path = 'api/v1/job_digests#create'
      expect(post: path).to route_to(route_path)
    end

    it 'routes to #update' do
      path = '/api/v1/job-digests/1'
      route_path = 'api/v1/job_digests#update'
      expect(patch: path).to route_to(route_path, job_digest_id: '1')
    end
  end
end
