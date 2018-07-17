# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BlocketjobbJobsSerializer do
  describe '#to_xml' do
    it 'returns the correct XML' do
      job = FactoryBot.create(
        :job_with_translation,
        translation_locale: :sv,
        blocketjobb_category: 'Övrigt',
        last_application_at: 2.weeks.from_now,
        publish_on_blocketjobb: true
      )
      job_view = Blocketjobb::JobWrapper.new(job, staffing_company: job.company)

      allow(AppConfig).to receive(:default_staffing_company_id).and_return(job.company.id)
      xml_string = BlocketjobbJobsSerializer.to_xml(jobs: [job], locale: I18n.locale)
      xml = Nokogiri::XML.parse(xml_string).css('jobfeed_xml_stucture ads ad')

      # Job data
      external_ad_id = xml.css('external_ad_id').text.strip
      display_at = xml.css('display_at').text.strip
      category = xml.css('category').first.attributes['cgID'].value
      subject = xml.css('subject').text.strip
      body = xml.css('body').text.strip
      job_ad_type = xml.css('job_ad_type').text.strip
      employment = xml.css('employment').text.strip
      apply_date = xml.css('apply_date').text.strip
      region = xml.css('region').text.strip
      region_name = xml.css('region_name').text.strip
      municipality = xml.css('municipality').text.strip
      address = xml.css('address').text.strip
      zipcode = xml.css('zipcode').text.strip

      expect(external_ad_id).to eq(job_view.external_ad_id)
      expect(display_at).to eq(job_view.display_at)
      expect(category).to eq(job_view.category)
      expect(subject).to eq(job_view.subject)
      expect(body).to eq(job_view.body.strip)
      expect(job_ad_type).to eq(job_view.job_ad_type)
      expect(employment).to eq(job_view.employment)
      expect(apply_date).to eq(job_view.apply_date)
      expect(region).to eq(job_view.region)
      expect(region_name).to eq(job_view.region_name)
      expect(municipality).to eq(job_view.municipality)
      expect(address).to eq(job_view.address)
      expect(zipcode).to eq(job_view.zipcode)

      # Company data
      corp_descr = xml.css('corp_descr').text.strip
      corp_name = xml.css('corp_name').text.strip
      corp_orgno = xml.css('corp_orgno').text.strip
      corp_url = xml.css('corp_url').text.strip

      expect(corp_descr).to eq(job_view.company_description)
      expect(corp_url).to eq(job_view.company_url)
      expect(corp_name).to eq(job_view.company_name)
      expect(corp_orgno).to eq(job_view.company_orgno)

      # Image data
      logo_node_url = xml.css('image customerLogo url').text.strip
      expect(logo_node_url).to eq(job_view.company_logo_url)

      # Meta data
      pub_date = xml.css('pub_date').text.strip
      update_date = xml.css('update_date').text.strip
      end_date = xml.css('end_date').text.strip
      provider_name = xml.css('provider_name').text.strip

      expect(pub_date).to eq(job_view.publication_date)
      expect(update_date).to eq(job_view.update_date)
      expect(end_date).to eq(job_view.end_date)
      expect(provider_name).to eq(job_view.provider_name)
    end
  end
end
