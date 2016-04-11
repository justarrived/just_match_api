# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::Users::ResetPasswordController, type: :routing do
  describe 'routing' do
    it 'routes post to #create' do
      path = '/api/v1/users/reset-password'

      route_path = 'api/v1/users/reset_password#create'
      expect(post: path).to route_to(route_path)
    end
  end
end
