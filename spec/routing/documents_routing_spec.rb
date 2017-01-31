# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::DocumentsController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      path = '/api/v1/documents/'
      route_path = 'api/v1/documents#create'
      expect(post: path).to route_to(route_path)
    end
  end
end
