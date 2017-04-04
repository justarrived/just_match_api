# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::EmailSuggestionsController, type: :routing do
  describe 'routing' do
    it 'routes to GET #suggest' do
      path = '/api/v1/email-suggestion'
      expect(get: path).to route_to('api/v1/email_suggestions#suggest')
    end

    it 'routes to POST #suggest' do
      path = '/api/v1/email-suggestion'
      expect(post: path).to route_to('api/v1/email_suggestions#suggest')
    end
  end
end
