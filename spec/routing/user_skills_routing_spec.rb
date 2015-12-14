require 'rails_helper'

RSpec.describe Api::V1::Users::UserSkillsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      path = '/api/v1/users/1/skills'
      route_path = 'api/v1/users/user_skills#index'
      expect(get: path).to route_to(route_path, user_id: '1')
    end

    it 'routes to #show' do
      path = '/api/v1/users/1/skills/1'
      route_path = 'api/v1/users/user_skills#show'
      expect(get: path).to route_to(route_path, user_id: '1', id: '1')
    end

    it 'routes to #create' do
      path = '/api/v1/users/1/skills'
      route_path = 'api/v1/users/user_skills#create'
      expect(post: path).to route_to(route_path, user_id: '1')
    end

    it 'routes to #destroy' do
      path = '/api/v1/users/1/skills/1'
      route_path = 'api/v1/users/user_skills#destroy'
      expect(delete: path).to route_to(route_path, user_id: '1', id: '1')
    end
  end
end
