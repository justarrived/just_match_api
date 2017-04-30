# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::PartnerFeeds::JobsController, type: :controller do
  describe 'GET #linkedin' do
    it 'returns linkedin jobs' do
      job = FactoryGirl.create(:job_with_translation, translation_locale: :en)
      token = 'nososecret'
      allow(AppSecrets).to receive(:linkedin_sync_key).and_return(token)

      request.content_type = 'application/json'
      get :linkedin, params: { auth_token: token }

      json = JSON.parse(response.body)
      first_job = json.first

      # Company data
      expect(first_job.dig('company', 'name')).to eq(job.company.name)
      expect(first_job.dig('company', 'id')).to eq(job.company.cin)
      expect(first_job.dig('company', 'country_code')).to eq('SE')
      expect(first_job.dig('company', 'postal_code')).to eq(job.company.zip)
      # Job data
      expect(first_job.dig('job', 'title')).to eq(job.name)
      expect(first_job.dig('job', 'description')).to eq(job.description)
      expect(first_job.dig('job', 'location')).to eq(job.full_street_address)
      expect(first_job.dig('job', 'country_code')).to eq('SE')
      expect(first_job.dig('job', 'postal_code')).to eq(job.zip)
      expect(first_job.dig('job', 'application_url')).to eq(FrontendRouter.draw(:job, id: job.id))
    end

    it 'returns 401 Unquthorized if an invalid key is passed' do
      job = FactoryGirl.create(:job)
      get :linkedin, params: { auth_token: 'thewrongkey' }
      expect(response.status).to eq(401)
    end

    it 'returns 401 Unquthorized if an no key is passed' do
      job = FactoryGirl.create(:job)
      get :linkedin
      expect(response.status).to eq(401)
    end
  end
end