# == Schema Information
#
# Table name: chats
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

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
      path = '/api/v1/chats/1/messages'
      route_path = 'api/v1/chats/messages#create'
      expect(post: path).to route_to(route_path, id: '1')
    end

    it 'routes to #messages' do
      path = '/api/v1/chats/1/messages'
      route_path = 'api/v1/chats/messages#index'
      expect(get: path).to route_to(route_path, id: '1')
    end
  end
end
