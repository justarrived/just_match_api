# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::PartnerFeeds::JobsController, type: :controller do
  describe 'GET #linkedin' do
    it 'returns linkedin jobs' do
      job = FactoryGirl.create(
        :job_with_translation,
        translation_locale: :en,
        publish_on_linkedin: true,
        last_application_at: 2.days.from_now
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
      token = 'nososecret'
      allow(AppSecrets).to receive(:blocketjobb_sync_key).and_return(token)

      request.content_type = 'application/json'
      get :blocketjobb, params: { auth_token: token }

      FactoryGirl.create(:job)
      get :blocketjobb, params: { auth_token: token }
      expect(response.status).to eq(200)
    end

    it 'returns 401 Unquthorized if an invalid key is passed' do
      FactoryGirl.create(:job)
      get :blocketjobb, params: { auth_token: 'thewrongkey' }
      expect(response.status).to eq(401)
    end

    it 'returns 401 Unquthorized if an no key is passed' do
      FactoryGirl.create(:job)
      get :blocketjobb
      expect(response.status).to eq(401)
    end
  end

  describe 'GET #metrojobb' do
    it 'generates correct XML' do
      job_model = FactoryGirl.create(
        :job_with_translation,
        translation_locale: :en,
        publish_on_metrojobb: true,
        last_application_at: 2.days.from_now,
        metrojobb_category: MetrojobbCategories.to_form_array.last.first,
        municipality: 'Stockholm'
      )
      job = Metrojobb::JobWrapper.new(job: job_model)

      token = 'nososecret'
      allow(AppSecrets).to receive(:metrojobb_sync_key).and_return(token)

      request.content_type = 'application/json'
      get :metrojobb, params: { auth_token: token }

      xml = Nokogiri::XML.parse(response.body)

      application_url = xml.css('applicationURL').text
      expect(application_url).to include("https://app.justarrived.se/job/#{job.job.to_param}") # rubocop:disable Metrics/LineLength

      expect(xml.css('ad').attribute('orderno').value).to eq(job.order_number.to_s)

      expect(xml.css('employer').text).to include(job.employer)
      expect(xml.css('externalApplication').text).to include('true')

      expect(xml.css('region id').text).to include('180')
      expect(xml.css('category id').text).to include('2402')
    end

    context 'auth' do
      it 'returns metrojobb jobs' do
        token = 'nososecret'
        allow(AppSecrets).to receive(:metrojobb_sync_key).and_return(token)

        request.content_type = 'application/json'
        get :metrojobb, params: { auth_token: token }

        FactoryGirl.create(:job)
        get :metrojobb, params: { auth_token: token }
        expect(response.status).to eq(200)
      end

      it 'returns 401 Unquthorized if an invalid key is passed' do
        FactoryGirl.create(:job)
        get :metrojobb, params: { auth_token: 'thewrongkey' }
        expect(response.status).to eq(401)
      end

      it 'returns 401 Unquthorized if an no key is passed' do
        FactoryGirl.create(:job)
        get :metrojobb
        expect(response.status).to eq(401)
      end
    end
  end
end
