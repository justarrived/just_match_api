# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Guides::GuideSectionArticlesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      path = '/api/v1/guides/sections/1/articles'
      expect(get: path).to route_to('api/v1/guides/guide_section_articles#index', section_id: '1') # rubocop:disable Metrics/LineLength
    end

    it 'routes to #show' do
      path = '/api/v1/guides/sections/3/articles/1'
      expect(get: path).to route_to('api/v1/guides/guide_section_articles#show', section_id: '3', article_id: '1') # rubocop:disable Metrics/LineLength
    end
  end
end
