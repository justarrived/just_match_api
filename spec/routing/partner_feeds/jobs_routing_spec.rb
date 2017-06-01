# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::PartnerFeeds::JobsController, type: :routing do
  describe 'routing' do
    it 'routes to #linkedin' do
      path = '/api/v1/partner-feeds/jobs/linkedin'
      route_path = 'api/v1/partner_feeds/jobs#linkedin'
      expect(get: path).to route_to(route_path)
    end

    it 'routes to #blocketjobb' do
      path = '/api/v1/partner-feeds/jobs/blocketjobb'
      route_path = 'api/v1/partner_feeds/jobs#blocketjobb'
      expect(get: path).to route_to(route_path)
    end
  end
end
