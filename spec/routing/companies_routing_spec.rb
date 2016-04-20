# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::CompaniesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      path = '/api/v1/companies/'
      route_path = 'api/v1/companies#index'
      expect(get: path).to route_to(route_path)
    end

    it 'routes to #show' do
      path = '/api/v1/companies/1/'
      route_path = 'api/v1/companies#show'
      expect(get: path).to route_to(route_path, id: '1')
    end

    it 'routes to #create' do
      path = '/api/v1/companies/'
      route_path = 'api/v1/companies#create'
      expect(post: path).to route_to(route_path)
    end
  end
end
