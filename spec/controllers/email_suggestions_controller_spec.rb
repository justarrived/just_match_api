# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::EmailSuggestionsController, type: :controller do
  describe 'GET #email_suggestion' do
    it 'correct response body' do
      params = {
        data: {
          attributes: { email: 'buren@example.co' }
        }
      }
      get :suggest, params: params
      expect(response.body).to include('buren@example.com')
    end
  end
end
