require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      path = '/api/v1/users'
      expect(get: path).to route_to('api/v1/users#index')
    end

    it 'routes to #show' do
      path = '/api/v1/users/1'
      expect(get: path).to route_to('api/v1/users#show', user_id: '1')
    end

    it 'routes to #create' do
      path = '/api/v1/users'
      expect(post: path).to route_to('api/v1/users#create')
    end

    it 'routes to #update via PUT' do
      path = '/api/v1/users/1'
      expect(put: path).to route_to('api/v1/users#update', user_id: '1')
    end

    it 'routes to #update via PATCH' do
      path = '/api/v1/users/1'
      expect(patch: path).to route_to('api/v1/users#update', user_id: '1')
    end

    it 'routes to #destroy' do
      path = '/api/v1/users/1'
      expect(delete: path).to route_to('api/v1/users#destroy', user_id: '1')
    end
  end
end
