# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Jobs::UsersController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      path = '/api/v1/jobs/1/users/1/missing-traits'
      route_path = 'api/v1/jobs/users#missing_traits'
      expect(get: path).to route_to(route_path, job_id: '1', user_id: '1')
    end

    it 'routes to #create' do
      path = '/api/v1/jobs/1/users/1/job-user'
      route_path = 'api/v1/jobs/users#job_user'
      expect(get: path).to route_to(route_path, job_id: '1', user_id: '1')
    end
  end
end
