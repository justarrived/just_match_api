# frozen_string_literal: true
require 'rails_helper'

RSpec.describe JobSerializer, type: :serializer do
  context 'Individual Resource Representation' do
    let(:resource) { FactoryGirl.build(:job, id: '17') }
    let(:serialization) { JsonApiSerializer.serialize(resource) }

    subject do
      JSON.parse(serialization.to_json)
    end

    ignore_fields = %i(
      id translated_text name description short_description amount
      gross_amount_with_currency net_amount_with_currency
      gross_amount_delimited net_amount_delimited description_html
    )
    (JobPolicy::ATTRIBUTES - ignore_fields).each do |attribute|
      it "has #{attribute.to_s.humanize.downcase}" do
        dashed_attribute = attribute.to_s.dasherize
        value = resource.public_send(attribute)
        expect(subject).to have_jsonapi_attribute(dashed_attribute, value)
      end
    end

    it 'has translated_text' do
      dashed_attribute = 'translated_text'.dasherize
      value = {
        'name' => nil,
        'description' => nil,
        'description_html'.dasherize => nil,
        'short_description'.dasherize => nil,
        'language_id'.dasherize => nil
      }
      expect(subject).to have_jsonapi_attribute(dashed_attribute, value)
    end

    it 'has net_amount_with_currency' do
      dashed_attribute = 'net_amount_with_currency'.dasherize
      expect(subject).to have_jsonapi_attribute(dashed_attribute, '2,100 SEK')
    end

    it 'has gross_amount_with_currency' do
      dashed_attribute = 'gross_amount_with_currency'.dasherize
      expect(subject).to have_jsonapi_attribute(dashed_attribute, '3,000 SEK')
    end

    it 'has net_amount_delimited' do
      dashed_attribute = 'net_amount_delimited'.dasherize
      expect(subject).to have_jsonapi_attribute(dashed_attribute, '2,100')
    end

    it 'has gross_amount_delimited' do
      dashed_attribute = 'gross_amount_delimited'.dasherize
      expect(subject).to have_jsonapi_attribute(dashed_attribute, '3,000')
    end

    it 'has currency' do
      expect(subject).to have_jsonapi_attribute('currency', 'SEK')
    end

    %w(owner company language category hourly-pay).each do |relationship|
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
#  filled                       :boolean          default(FALSE)
#  short_description            :string
#  featured                     :boolean          default(FALSE)
#  upcoming                     :boolean          default(FALSE)
#  company_contact_user_id      :integer
#  just_arrived_contact_user_id :integer
#  city                         :string
#  staffing_job                 :boolean          default(FALSE)
#  direct_recruitment_job       :boolean          default(FALSE)
#
# Indexes
#
#  index_jobs_on_category_id    (category_id)
#  index_jobs_on_hourly_pay_id  (hourly_pay_id)
#  index_jobs_on_language_id    (language_id)
#
# Foreign Keys
#
#  fk_rails_1cf0b3b406                   (category_id => categories.id)
#  fk_rails_70cb33aa57                   (language_id => languages.id)
#  fk_rails_b144fc917d                   (hourly_pay_id => hourly_pays.id)
#  jobs_company_contact_user_id_fk       (company_contact_user_id => users.id)
#  jobs_just_arrived_contact_user_id_fk  (just_arrived_contact_user_id => users.id)
#  jobs_owner_user_id_fk                 (owner_user_id => users.id)
#
