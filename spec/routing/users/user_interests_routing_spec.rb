# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Users::UserInterestsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      path = '/api/v1/users/1/interests'
      route_path = 'api/v1/users/user_interests#index'
      expect(get: path).to route_to(route_path, user_id: '1')
    end

    it 'routes to #show' do
      path = '/api/v1/users/1/interests/1'
      route_path = 'api/v1/users/user_interests#show'
      expect(get: path).to route_to(route_path, user_id: '1', user_interest_id: '1')
    end

    it 'routes to #create' do
      path = '/api/v1/users/1/interests'
      route_path = 'api/v1/users/user_interests#create'
      expect(post: path).to route_to(route_path, user_id: '1')
    end

    it 'routes to #destroy' do
      path = '/api/v1/users/1/interests/1'
      route_path = 'api/v1/users/user_interests#destroy'
      expect(delete: path).to route_to(route_path, user_id: '1', user_interest_id: '1')
    end
  end
end
