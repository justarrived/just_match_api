# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Users::UserOccupationsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      path = '/api/v1/users/1/occupations'
      route_path = 'api/v1/users/user_occupations#index'
      expect(get: path).to route_to(route_path, user_id: '1')
    end

    it 'routes to #show' do
      path = '/api/v1/users/1/occupations/1'
      route_path = 'api/v1/users/user_occupations#show'
      expect(get: path).to route_to(route_path, user_id: '1', user_occupation_id: '1')
    end

    it 'routes to #create' do
      path = '/api/v1/users/1/occupations'
      route_path = 'api/v1/users/user_occupations#create'
      expect(post: path).to route_to(route_path, user_id: '1')
    end

    it 'routes to #destroy' do
      path = '/api/v1/users/1/occupations/1'
      route_path = 'api/v1/users/user_occupations#destroy'
      expect(delete: path).to route_to(route_path, user_id: '1', user_occupation_id: '1')
    end
  end
end
