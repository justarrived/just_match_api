# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Guides::GuideSectionsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      path = '/api/v1/guides/sections/'
      expect(get: path).to route_to('api/v1/guides/guide_sections#index')
    end

    it 'routes to #show' do
      path = '/api/v1/guides/sections/1'
      expect(get: path).to route_to('api/v1/guides/guide_sections#show', section_id: '1')
    end
  end
end
