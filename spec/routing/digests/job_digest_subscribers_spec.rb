# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Digests::JobDigestSubscribersController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      path = '/api/v1/digests/subscribers'
      route_path = 'api/v1/digests/job_digest_subscribers#create'
      expect(post: path).to route_to(route_path)
    end

    it 'routes to #delete' do
      path = '/api/v1/digests/subscribers/1'
      route_path = 'api/v1/digests/job_digest_subscribers#destroy'
      expect(delete: path).to route_to(route_path, job_digest_subscriber_id: '1')
    end
  end
end
