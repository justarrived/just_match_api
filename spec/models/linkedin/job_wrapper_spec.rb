# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Linkedin::JobWrapper do
  let(:job) { FactoryGirl.build(:job, id: 73) }
  let(:job_wrapper) { described_class.new(job: job) }

  describe '#description' do
    it 'includes #welcometalent tag' do
      expect(job_wrapper.description).to include('#welcometalent')
    end
  end

  describe '#title' do
    it 'returns job name' do
      expect(job_wrapper.title).to eq(job.name)
    end
  end

  describe '#city' do
    it 'returns job city' do
      expect(job_wrapper.city).to eq(job.city)
    end
  end

  describe '#country_code' do
    it 'returns job country code' do
      expect(job_wrapper.country_code).to eq(job.country_code)
    end
  end

  describe '#postal_code' do
    it 'returns job zip' do
      expect(job_wrapper.postal_code).to eq(job.zip)
    end
  end

  describe '#location' do
    it 'returns job full street address' do
      expect(job_wrapper.location).to eq(job.full_street_address)
    end
  end

  describe '#company_name' do
    it 'returns company name' do
      expect(job_wrapper.company_name).to eq(job.company.name)
    end
  end

  describe '#apply_url' do
    it 'returns apply url' do
      url = job_wrapper.apply_url
      expect(url).to include('https://app.justarrived.se/job/')
      expect(url).to include('utm_source=linkedin')
      expect(url).to include('utm_medium=ad')
      expect(url).to include('utm_campaign=welcometalent')
      expect(url).to include("utm_content=#{job.to_param}")
    end
  end
end
