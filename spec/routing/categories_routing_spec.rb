# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::CategoriesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      path = '/api/v1/categories/'
      route_path = 'api/v1/categories#index'
      expect(get: path).to route_to(route_path)
    end
  end
end
