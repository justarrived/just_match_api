# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::Users::ChangePasswordController, type: :routing do
  describe 'routing' do
    it 'routes post to #create' do
      path = '/api/v1/users/change-password'

      route_path = 'api/v1/users/change_password#create'
      expect(post: path).to route_to(route_path)
    end
  end
end
