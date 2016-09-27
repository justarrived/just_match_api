# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::Users::UserChatsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      path = '/api/v1/users/1/chats'
      route_path = 'api/v1/users/user_chats#index'
      expect(get: path).to route_to(route_path, user_id: '1')
    end

    it 'routes to #show' do
      path = '/api/v1/users/1/chats/1'
      route_path = 'api/v1/users/user_chats#show'
      expect(get: path).to route_to(route_path, user_id: '1', id: '1')
    end
  end
end
