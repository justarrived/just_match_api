# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::Chats::ChatMessagesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      path = '/api/v1/chats/1/messages'
      route_path = 'api/v1/chats/chat_messages#index'
      expect(get: path).to route_to(route_path, id: '1')
    end

    it 'routes to #create' do
      path = '/api/v1/chats/1/messages'
      route_path = 'api/v1/chats/chat_messages#create'
      expect(post: path).to route_to(route_path, id: '1')
    end
  end
end
