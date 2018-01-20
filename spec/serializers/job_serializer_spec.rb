# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobSerializer, type: :serializer do
  context 'Individual Resource Representation' do
    let(:resource) { FactoryBot.build(:job, id: '17') }
    let(:serialization) { JsonApiSerializer.serialize(resource) }

    subject do
      JSON.parse(serialization.to_json)
    end

    ignore_fields = %i(
      id translated_text name description short_description amount
      gross_amount_with_currency net_amount_with_currency
      gross_amount_delimited net_amount_delimited description_html
      last_application_at_in_words open_for_applications starts_in_the_future
      tasks_description_html applicant_description_html requirements_description_html
      frilans_finans_job schema_org
    )
    (JobPolicy::ATTRIBUTES - ignore_fields).each do |attribute|
      it "has #{attribute.to_s.humanize.downcase}" do
        value = resource.public_send(attribute)
        expect(subject).to have_jsonapi_attribute(attribute.to_s, value)
      end
    end

    it 'has translated_text' do
      value = {
        'name' => nil,
        'description' => nil,
        'description_html' => nil,
        'short_description' => nil,
        'language_id' => nil,
        'tasks_description' => nil,
        'tasks_description_html' => nil,
        'applicant_description' => nil,
        'applicant_description_html' => nil,
        'requirements_description' => nil,
        'requirements_description_html' => nil
      }
      expect(subject).to have_jsonapi_attribute('translated_text', value)
    end

    it 'has schema_org contains @type: JobPosting' do
      value = subject.dig('data', 'attributes', 'schema_org', 'job_position')['@type']
      expect(value).to eq('JobPosting')
    end

    it 'has net_amount_with_currency' do
      expect(subject).to have_jsonapi_attribute('net_amount_with_currency', '2,100 SEK')
    end

    it 'has gross_amount_with_currency' do
      attribute = 'gross_amount_with_currency'
      expect(subject).to have_jsonapi_attribute(attribute, '3,000 SEK')
    end

    it 'has net_amount_delimited' do
      attribute = 'net_amount_delimited'
      expect(subject).to have_jsonapi_attribute(attribute, '2,100')
    end

    it 'has gross_amount_delimited' do
      attribute = 'gross_amount_delimited'
      expect(subject).to have_jsonapi_attribute(attribute, '3,000')
    end

    it 'has currency' do
      expect(subject).to have_jsonapi_attribute('currency', 'SEK')
    end

    it 'has frilans_finans_job' do
      expect(subject).to have_jsonapi_attribute('frilans_finans_job', true)
    end

    %w(
      owner company language category hourly_pay job_languages job_skills job_occupations
    ).each do |relationship|
      it "has #{relationship} relationship" do
        expect(subject).to have_jsonapi_relationship(relationship)
      end
    end

    it 'is valid jsonapi format' do
      expect(subject).to be_jsonapi_formatted('jobs')
    end
  end
end

# == Schema Information
#
# Table name: jobs
#
#  id                           :integer          not null, primary key
#  description                  :text
#  job_date                     :datetime
#  hours                        :float
#  name                         :string
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  owner_user_id                :integer
#  latitude                     :float
#  longitude                    :float
#  language_id                  :integer
#  street                       :string
#  zip                          :string
#  zip_latitude                 :float
#  zip_longitude                :float
#  hidden                       :boolean          default(FALSE)
#  category_id                  :integer
#  hourly_pay_id                :integer
#  verified                     :boolean          default(FALSE)
#  job_end_date                 :datetime
#  cancelled                    :boolean          default(FALSE)
#  short_description            :string
#  featured                     :boolean          default(FALSE)
#  upcoming                     :boolean          default(FALSE)
#  company_contact_user_id      :integer
#  just_arrived_contact_user_id :integer
#  city                         :string
#  staffing_job                 :boolean          default(FALSE)
#  direct_recruitment_job       :boolean          default(FALSE)
#  order_id                     :integer
#  municipality                 :string
#  number_to_fill               :integer          default(1)
#  full_time                    :boolean          default(FALSE)
#  swedish_drivers_license      :string
#  car_required                 :boolean          default(FALSE)
#  salary_type                  :integer          default("fixed")
#  publish_on_linkedin          :boolean          default(FALSE)
#  publish_on_blocketjobb       :boolean          default(FALSE)
#  last_application_at          :datetime
#  blocketjobb_category         :string
#  publish_at                   :datetime
#  unpublish_at                 :datetime
#  tasks_description            :text
#  applicant_description        :text
#  requirements_description     :text
#  preview_key                  :string
#  customer_hourly_price        :decimal(, )
#  invoice_comment              :text
#  publish_on_metrojobb         :boolean          default(FALSE)
#  metrojobb_category           :string
#  staffing_company_id          :integer
#  cloned                       :boolean          default(FALSE)
#  filled_at                    :datetime
#
# Indexes
#
#  index_jobs_on_category_id          (category_id)
#  index_jobs_on_hourly_pay_id        (hourly_pay_id)
#  index_jobs_on_language_id          (language_id)
#  index_jobs_on_order_id             (order_id)
#  index_jobs_on_staffing_company_id  (staffing_company_id)
#
# Foreign Keys
#
#  fk_rails_...                          (category_id => categories.id)
#  fk_rails_...                          (hourly_pay_id => hourly_pays.id)
#  fk_rails_...                          (language_id => languages.id)
#  fk_rails_...                          (order_id => orders.id)
#  jobs_company_contact_user_id_fk       (company_contact_user_id => users.id)
#  jobs_just_arrived_contact_user_id_fk  (just_arrived_contact_user_id => users.id)
#  jobs_owner_user_id_fk                 (owner_user_id => users.id)
#
