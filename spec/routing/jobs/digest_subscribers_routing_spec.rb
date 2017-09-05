# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Jobs::DigestSubscribersController, type: :routing do
  describe 'routing' do
    it 'routes to #show' do
      path = '/api/v1/jobs/subscribers/uuid'
      route_path = 'api/v1/jobs/digest_subscribers#show'
      expect(get: path).to route_to(route_path, digest_subscriber_id: 'uuid')
    end

    it 'routes to #create' do
      path = '/api/v1/jobs/subscribers'
      route_path = 'api/v1/jobs/digest_subscribers#create'
      expect(post: path).to route_to(route_path)
    end

    it 'routes to #delete' do
      path = '/api/v1/jobs/subscribers/1'
      route_path = 'api/v1/jobs/digest_subscribers#destroy'
      expect(delete: path).to route_to(route_path, digest_subscriber_id: '1')
    end
  end
end
