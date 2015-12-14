require 'rails_helper'

RSpec.describe 'Jobs', type: :request do
  describe 'GET /jobs' do
    it 'works!' do
      get api_v1_jobs_path
      expect(response).to have_http_status(200)
    end
  end
end
