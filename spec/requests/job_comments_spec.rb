# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'JobComments', type: :request do
  describe 'GET /jobs/1/comments' do
    it 'works!' do
      job = FactoryGirl.create(:job)
      get api_v1_job_comments_path(job_id: job.to_param)
      expect(response).to have_http_status(200)
    end
  end
end
