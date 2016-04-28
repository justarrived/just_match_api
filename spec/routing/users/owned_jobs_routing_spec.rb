# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::Users::OwnedJobsController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      path = '/api/v1/users/1/owned-jobs'
      route_path = 'api/v1/users/owned_jobs#index'
      expect(get: path).to route_to(route_path, user_id: '1')
    end

    it 'routes to #show' do
      path = '/api/v1/users/1/owned-jobs'
      route_path = 'api/v1/users/owned_jobs#index'
      expect(get: path).to route_to(route_path, user_id: '1')
    end
  end
end
