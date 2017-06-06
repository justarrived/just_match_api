# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::PartnerFeeds::JobsController, type: :controller do
  describe 'GET #linkedin' do
    it 'returns linkedin jobs' do
      job = FactoryGirl.create(
        :job_with_translation,
        translation_locale: :en,
        publish_on_linkedin: true
      )
      token = 'nososecret'
      allow(AppSecrets).to receive(:linkedin_sync_key).and_return(token)

      request.content_type = 'application/json'
      get :linkedin, params: { auth_token: token }

      xml = Nokogiri::XML.parse(response.body).css('source')

      publisher_url = xml.css('publisherUrl').text
      expect(publisher_url).to eq('https://justarrived.se')

      publisher = xml.css('publisher').text
      expect(publisher).to eq('Just Arrived')

      job_fragment = xml.css('job')

      # Company data
      expect(job_fragment.css('company').text.strip).to eq(job.company.name)
      # Location data
      expect(job_fragment.css('location').text.strip).to eq(job.full_street_address)
      expect(job_fragment.css('city').text.strip).to eq(job.city)
      expect(job_fragment.css('countryCode').text.strip).to eq('SE')
      expect(job_fragment.css('postalCode').text.strip).to eq(job.zip)
      # Job data
      expect(job_fragment.css('title').text.strip).to eq(job.name)
      expect(job_fragment.css('description').text).to include(job.description)
      expect(job_fragment.css('description').text).to include('#welcometalent')

      apply_url = "https://app.justarrived.se/job/#{job.id}?utm_source=linkedin&utm_medium=ad&utm_campaign=welcometalent&utm_content=#{job.to_param}" # rubocop:disable Metrics/LineLength
      expect(job_fragment.css('applyUrl').text.strip).to eq(apply_url)
    end

    it 'returns 401 Unquthorized if an invalid key is passed' do
      FactoryGirl.create(:job)
      get :linkedin, params: { auth_token: 'thewrongkey' }
      expect(response.status).to eq(401)
    end

    it 'returns 401 Unquthorized if an no key is passed' do
      FactoryGirl.create(:job)
      get :linkedin
      expect(response.status).to eq(401)
    end
  end

  describe 'GET #blocketjobb' do
    it 'returns blocketjobb jobs' do
      request.content_type = 'application/json'
      FactoryGirl.create(:job)
      get :blocketjobb
      expect(response.status).to eq(200)
    end
  end
end
