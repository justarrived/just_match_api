require 'rails_helper'

RSpec.describe 'JobSkills', type: :request do
  describe 'GET /job_skills' do
    it 'works!' do
      job = FactoryGirl.create(:job)
      get api_v1_job_skills_path(job_id: job.to_param)
      expect(response).to have_http_status(200)
    end
  end
end
