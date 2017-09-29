# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Blocketjobb::JobWrapper do
  describe '#external_ad_id' do
    it 'returns the jobs id' do
      job = FactoryGirl.build(:job, id: '1')

      wrapper = described_class.new(job)
      expect(wrapper.external_ad_id).to eq(job.id.to_s)
    end
  end

  describe '#apply_url' do
    it 'returns the apply_url' do
      job = FactoryGirl.build(:job, id: '1')

      url = "https://app.justarrived.se/job/1?utm_source=blocketjobb&utm_medium=ad&utm_content=#{job.to_param}" # rubocop:disable Metrics/LineLength
      wrapper = described_class.new(job)
      expect(wrapper.apply_url).to eq(url)
    end
  end

  describe '#display_at' do
    it 'returns the jobs id' do
      job = FactoryGirl.build(:job)
      wrapper = described_class.new(job)
      expect(wrapper.display_at).to eq('jobb')
    end
  end

  describe '#provider_name' do
    it 'returns the jobs id' do
      job = FactoryGirl.build(:job)
      wrapper = described_class.new(job)
      expect(wrapper.provider_name).to eq('JustMatch')
    end
  end

  describe '#category' do
    it 'returns the jobs id' do
      job = FactoryGirl.build(:job, blocketjobb_category: 'Övrigt')
      wrapper = described_class.new(job)
      expect(wrapper.category).to eq('9380')
    end
  end

  describe '#subject' do
    it 'returns the jobs id' do
      job = FactoryGirl.build(:job, name: 'job name')
      wrapper = described_class.new(job)
      expect(wrapper.subject).to eq('job name')
    end
  end

  describe '#body' do
    it 'returns the jobs id' do
      job = FactoryGirl.build(:job, description: 'job desc')
      body = "<p>job desc</p>\n"
      wrapper = described_class.new(job)
      expect(wrapper.body).to eq(body)
    end
  end

  describe '#company_logo_url' do
    it 'returns the company logo if there is one' do
      company = FactoryGirl.create(:company)
      company_image = FactoryGirl.create(:company_image, company: company)

      owner = FactoryGirl.create(:company_user, company: company)
      job = FactoryGirl.build(:job, owner: owner)

      logo_url = company_image.image.url(:large)
      wrapper = described_class.new(job)
      expect(wrapper.company_logo_url).to eq(logo_url)
    end

    it 'returns configured logo if there is an Environment variable for it' do
      expected = 'https://example.com/image.jpg'
      allow(AppConfig).to receive(:blocketjobb_customer_logo_url).and_return(expected)
      job = FactoryGirl.build(:job)
      wrapper = described_class.new(job)
      expect(wrapper.company_logo_url).to eq(expected)
    end

    it 'returns empty string if there is no company logo' do
      owner = FactoryGirl.create(:company_user)
      job = FactoryGirl.build(:job, owner: owner)

      wrapper = described_class.new(job)
      expect(wrapper.company_logo_url).to eq('')
    end
  end

  describe '#municipality' do
    it 'returns the correct municipality' do
      job = FactoryGirl.build(:job, municipality: 'Kiruna')
      wrapper = described_class.new(job)
      expect(wrapper.municipality).to eq('8')
    end
  end

  describe '#region' do
    it 'returns the correct region' do
      job = FactoryGirl.build(:job, municipality: 'Kiruna')
      wrapper = described_class.new(job)
      expect(wrapper.region).to eq('1')
    end
  end

  describe '#region_name' do
    it 'returns the correct region name' do
      job = FactoryGirl.build(:job, municipality: 'Kiruna')
      wrapper = described_class.new(job)
      expect(wrapper.region_name).to eq('Norrbotten')
    end
  end

  xdescribe '#categories'
  xdescribe '#header_logo'

  describe '#publication_date' do
    it 'returns the jobs creation date' do
      time = Time.zone.now
      job = FactoryGirl.build(:job, created_at: time)

      wrapper = described_class.new(job)
      expect(wrapper.publication_date).to eq(time.strftime('%Y-%m-%d'))
    end
  end

  describe '#update_date' do
    it 'returns the jobs update date' do
      time = Time.zone.now
      job = FactoryGirl.build(:job, updated_at: time)

      wrapper = described_class.new(job)
      expect(wrapper.update_date).to eq(time.strftime('%Y-%m-%d'))
    end
  end

  describe '#end_date' do
    it 'returns the jobs last_application_at date' do
      time = 2.weeks.from_now
      job = FactoryGirl.build(:job, last_application_at: time)

      wrapper = described_class.new(job)
      expect(wrapper.end_date).to eq(time.strftime('%Y-%m-%d'))
    end
  end

  describe '#apply_date' do
    context 'last_application_at after 60 days from now' do
      it 'returns 60 days from now formatterd as a stirng: YYYY-MM-DD' do
        time = 80.days.from_now
        job = FactoryGirl.create(:job_with_translation, last_application_at: time)

        yyyy_mm_dd = 60.days.from_now.strftime('%Y-%m-%d')
        wrapper = described_class.new(job)
        expect(wrapper.apply_date).to eq(yyyy_mm_dd)
      end
    end

    context 'last_application_at before 2 days from now' do
      it 'returns 2 days from now formatterd as a stirng: YYYY-MM-DD' do
        time = 1.day.ago
        job = FactoryGirl.create(:job_with_translation, last_application_at: time)

        yyyy_mm_dd = 2.days.from_now.strftime('%Y-%m-%d')
        wrapper = described_class.new(job)
        expect(wrapper.apply_date).to eq(yyyy_mm_dd)
      end
    end
  end

  describe '#employment' do
    it 'returns "1" when job is full time' do
      job = FactoryGirl.build(:job, full_time: true)

      wrapper = described_class.new(job)
      expect(wrapper.employment).to eq('1')
    end

    it 'returns "2" when job is not full time' do
      job = FactoryGirl.build(:job, full_time: false)

      wrapper = described_class.new(job)
      expect(wrapper.employment).to eq('2')
    end
  end

  describe '#job_ad_type' do
    it 'returns "2" when job is a direct recruitment job' do
      job = FactoryGirl.build(:job, direct_recruitment_job: true)

      wrapper = described_class.new(job)
      expect(wrapper.job_ad_type).to eq('2')
    end

    it 'returns "3" when job is not direct recruitment' do
      job = FactoryGirl.build(:job, direct_recruitment_job: false)

      wrapper = described_class.new(job)
      expect(wrapper.job_ad_type).to eq('3')
    end
  end

  describe '#address' do
    it 'returns the company address' do
      owner = FactoryGirl.create(:company_user)
      job = FactoryGirl.build(:job, owner: owner)

      wrapper = described_class.new(job)
      expect(wrapper.address).to eq(owner.company.address)
    end
  end

  describe '#zipcode' do
    it 'returns the company zipcode' do
      owner = FactoryGirl.create(:company_user)
      job = FactoryGirl.build(:job, owner: owner)

      wrapper = described_class.new(job)
      expect(wrapper.zipcode).to eq(owner.company.zip)
    end
  end

  describe '#company_name' do
    it 'returns the company name' do
      owner = FactoryGirl.create(:company_user)
      job = FactoryGirl.build(:job, owner: owner)

      wrapper = described_class.new(job)
      expect(wrapper.company_name).to eq(owner.company.name)
    end
  end

  describe '#company_orgno' do
    it 'returns the company name' do
      owner = FactoryGirl.create(:company_user)
      job = FactoryGirl.build(:job, owner: owner)

      wrapper = described_class.new(job)
      expect(wrapper.company_orgno).to eq(owner.company.cin)
    end
  end

  describe '#company_description' do
    it 'returns the company name' do
      owner = FactoryGirl.create(:company_user)
      job = FactoryGirl.build(:job, owner: owner)

      result = described_class.new(job).company_description
      expect(result).to eq(owner.company.guaranteed_description)
    end
  end

  describe '#company_url' do
    it 'returns the company name' do
      owner = FactoryGirl.create(:company_user)
      job = FactoryGirl.build(:job, owner: owner)

      wrapper = described_class.new(job)
      expect(wrapper.company_url).to eq(owner.company.website)
    end
  end
end
