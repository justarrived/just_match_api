# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::PromoCodesController, type: :routing do
  describe 'routing' do
    it 'routes to #validate' do
      path = '/api/v1/promo-codes/validate'
      route_path = 'api/v1/promo_codes#validate'
      expect(post: path).to route_to(route_path)
    end
  end
end
