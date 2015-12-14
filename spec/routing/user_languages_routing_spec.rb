require 'rails_helper'

RSpec.describe Api::V1::Users::UserLanguagesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      path = '/api/v1/users/1/languages'
      route_path = 'api/v1/users/user_languages#index'
      expect(get: path).to route_to(route_path, user_id: '1')
    end

    it 'routes to #show' do
      path = '/api/v1/users/1/languages/1'
      route_path = 'api/v1/users/user_languages#show'
      expect(get: path).to route_to(route_path, user_id: '1', id: '1')
    end

    it 'routes to #create' do
      path = '/api/v1/users/1/languages'
      route_path = 'api/v1/users/user_languages#create'
      expect(post: path).to route_to(route_path, user_id: '1')
    end

    it 'routes to #destroy' do
      path = '/api/v1/users/1/languages/1'
      route_path = 'api/v1/users/user_languages#destroy'
      expect(delete: path).to route_to(route_path, user_id: '1', id: '1')
    end
  end
end
