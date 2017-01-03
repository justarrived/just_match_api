# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::Users::UserImagesController, type: :routing do
  describe 'routing' do
    it 'routes to #show' do
      path = '/api/v1/users/1/images/1'
      route_path = 'api/v1/users/user_images#show'
      expect(get: path).to route_to(route_path, user_id: '1', id: '1')
    end
  end
end
