# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::TermsAgreementConsentsController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      path = '/api/v1/terms-consents'
      route_path = 'api/v1/terms_agreement_consents#create'
      expect(post: path).to route_to(route_path)
    end
  end
end
