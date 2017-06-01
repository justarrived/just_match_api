# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Companies::CompanyImagesController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      path = '/api/v1/companies/images'
      route_path = 'api/v1/companies/company_images#create'
      expect(post: path).to route_to(route_path)
    end

    it 'routes to #show' do
      path = '/api/v1/companies/1/images/1'
      route_path = 'api/v1/companies/company_images#show'
      expect(get: path).to route_to(route_path, company_id: '1', id: '1')
    end
  end
end
