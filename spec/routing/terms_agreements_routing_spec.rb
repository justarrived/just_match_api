# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::TermsAgreementsController, type: :routing do
  describe 'routing' do
    it 'routes to #current' do
      path = '/api/v1/terms-agreements/current'
      expect(get: path).to route_to('api/v1/terms_agreements#current')
    end
  end
end
