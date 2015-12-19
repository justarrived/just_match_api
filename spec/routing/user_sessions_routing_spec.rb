require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :routing do
  describe 'routing' do
    it 'routes to #token' do
      path = '/api/v1/token'
      route_path = 'api/v1/user_sessions#token'
      expect(post: path).to route_to(route_path)
    end
  end
end
