# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SchemaOrg::JobPosting do
  describe '#to_h' do
    let(:description) { 'wat' }
    let(:company) { FactoryBot.build(:company) }
    let(:job) do
      FactoryBot.build_stubbed(:job, description: description, full_time: true)
    end
    let(:occupation_name) { 'Test occupation' }
    let(:occupation) { FactoryBot.build(:occupation, name: occupation_name) }
    let(:job_posting_data) do
      described_class.new(
        job: job,
        company: company,
        main_occupation: occupation
      ).to_h
    end

    it 'has the correct "@context" value' do
      expect(job_posting_data['@context']).to eq('http://schema.org')
    end

    it 'has the correct "@type" value' do
      expect(job_posting_data['@type']).to eq('JobPosting')
    end

    it 'has the correct "identifier" value' do
      expected = {
        '@type' => 'PropertyValue',
        'name' => company.name,
        'value' => job.id
      }
      expect(job_posting_data['identifier']).to eq(expected)
    end

    it 'has the correct "datePosted" value' do
      expected = DateFormatter.new.yyyy_mm_dd(job.publish_at)
      expect(job_posting_data['datePosted']).to eq(expected)
    end

    it 'has the correct "description" value' do
      expect(job_posting_data['description']).to eq(description)
    end

    it 'has the correct "qualifications" value' do
      expect(job_posting_data['qualifications']).to eq(job.requirements_description)
    end

    it 'has the correct "responsibilities" value' do
      expect(job_posting_data['responsibilities']).to eq(job.tasks_description)
    end

    it 'has the correct "skills" value' do
      expect(job_posting_data['skills']).to eq(job.applicant_description)
    end

    it 'has the correct "employmentType" value' do
      expect(job_posting_data['employmentType']).to eq(['FULL_TIME'])
    end

    it 'has the correct "title" value' do
      expect(job_posting_data['title']).to eq(occupation_name)
    end

    it 'has the correct "hiringOrganization" value' do
      expected = {
        '@type' => 'Organization',
        'name' => company.name,
        'sameAs' => company.website,
        'logo' => nil
      }
      expect(job_posting_data['hiringOrganization']).to eq(expected)
    end

    it 'has the correct "jobLocation" value' do
      expected = {
        '@type' => 'Place',
        'address' => {
          '@type' => 'PostalAddress',
          'streetAddress' => job.street,
          'addressLocality' => job.city,
          'postalCode' => job.zip,
          'addressCountry' => job.country_code
        }
      }
      expect(job_posting_data['jobLocation']).to eq(expected)
    end

    context 'with last_application_at unset' do
      let(:job) { FactoryBot.build_stubbed(:job, last_application_at: nil) }

      it 'does not include a "validThrough" key' do
        expect(job_posting_data.key?('validThrough')).to eq(false)
      end
    end

    context 'with last_application_at set' do
      let(:job) { FactoryBot.build_stubbed(:job, last_application_at: 1.week.from_now) }

      it 'has "validThrough" attribute in YYYY-MM-DD format' do
        expected = DateFormatter.new.yyyy_mm_dd(job.last_application_at)
        expect(job_posting_data['validThrough']).to eq(expected)
      end
    end
  end
end
