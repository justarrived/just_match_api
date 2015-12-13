require 'rails_helper'

RSpec.describe 'Languages', type: :request do
  describe 'GET /languages' do
    it 'works!' do
      get api_v1_languages_path(id: 1)
      expect(response).to have_http_status(200)
    end
  end
end
