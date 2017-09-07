# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Jobs::JobDigestsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      path = '/api/v1/jobs/subscribers/1/digests'
      route_path = 'api/v1/jobs/job_digests#index'
      expect(get: path).to route_to(route_path, digest_subscriber_id: '1')
    end

    it 'routes to #create' do
      path = '/api/v1/jobs/digests'
      route_path = 'api/v1/jobs/job_digests#create'
      expect(post: path).to route_to(route_path)
    end

    it 'routes to #update' do
      path = '/api/v1/jobs/subscribers/1/digests/2'
      route_path = 'api/v1/jobs/job_digests#update'
      expect(patch: path).to route_to(route_path, digest_subscriber_id: '1', job_digest_id: '2') # rubocop:disable Metrics/LineLength
    end

    it 'routes to #destroy' do
      path = '/api/v1/jobs/subscribers/1/digests/2'
      route_path = 'api/v1/jobs/job_digests#destroy'
      expect(delete: path).to route_to(route_path, digest_subscriber_id: '1', job_digest_id: '2') # rubocop:disable Metrics/LineLength
    end

    it 'routes to #notification_frequencies' do
      path = '/api/v1/jobs/digests/notification-frequencies'
      route_path = 'api/v1/jobs/job_digests#notification_frequencies'
      expect(get: path).to route_to(route_path)
    end
  end
end
