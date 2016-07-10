# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::CountriesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      path = '/api/v1/countries/'
      route_path = 'api/v1/countries#index'
      expect(get: path).to route_to(route_path)
    end
  end
end
