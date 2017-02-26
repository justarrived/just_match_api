# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::Users::UserDocumentsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      path = '/api/v1/users/1/documents'
      route_path = 'api/v1/users/user_documents#index'
      expect(get: path).to route_to(route_path, user_id: '1')
    end

    it 'routes to #create' do
      path = '/api/v1/users/1/documents'
      route_path = 'api/v1/users/user_documents#create'
      expect(post: path).to route_to(route_path, user_id: '1')
    end
  end
end
