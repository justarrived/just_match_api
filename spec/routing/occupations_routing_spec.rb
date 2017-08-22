# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::OccupationsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      path = '/api/v1/occupations'
      expect(get: path).to route_to('api/v1/occupations#index')
    end

    it 'routes to #show' do
      path = '/api/v1/occupations/1'
      expect(get: path).to route_to('api/v1/occupations#show', id: '1')
    end
  end
end
