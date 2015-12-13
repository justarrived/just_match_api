require 'rails_helper'

RSpec.describe 'JobUsers', type: :request do
  describe 'GET /job_users' do
    it 'works!' do
      job = FactoryGirl.create(:job)
      get api_v1_job_users_path(job_id: job.to_param)
      expect(response).to have_http_status(200)
    end
  end
end
