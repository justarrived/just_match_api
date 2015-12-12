require 'rails_helper'

RSpec.describe Api::V1::ChatsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/chats').to route_to('api/v1/chats#index')
    end

    it 'routes to #show' do
      expect(get: '/api/v1/chats/1').to route_to('api/v1/chats#show', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/api/v1/chats').to route_to('api/v1/chats#create')
    end

    it 'routes to #messages' do
      expect(post: '/api/v1/chats/1/messages').to route_to('api/v1/chats#create_message', id: '1')
    end

    it 'routes to #messages' do
      expect(get: '/api/v1/chats/1/messages').to route_to('api/v1/chats#messages', id: '1')
    end
  end
end
