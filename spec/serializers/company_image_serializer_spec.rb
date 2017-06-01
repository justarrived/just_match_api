# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CompanyImageSerializer, type: :serializer do
  context 'Individual Resource Representation' do
    let(:resource) { FactoryGirl.build(:company_image, id: '1') }
    let(:serialization) { JsonApiSerializer.serialize(resource) }

    subject do
      JSON.parse(serialization.to_json)
    end

    it 'has category_name' do
      expect(subject).to have_jsonapi_attribute('category_name', 'logo')
    end

    it 'has image_url' do
      value = resource.image.url
      expect(subject).to have_jsonapi_attribute('image_url', value)
    end

    it 'has image_url_large' do
      value = resource.image.url(:large)
      expect(subject).to have_jsonapi_attribute('image_url_large', value)
    end

    it 'has image_url_medium' do
      value = resource.image.url(:medium)
      expect(subject).to have_jsonapi_attribute('image_url_medium', value)
    end

    it 'has image_url_small' do
      value = resource.image.url(:small)
      expect(subject).to have_jsonapi_attribute('image_url_small', value)
    end

    described_class::ATTRIBUTES.each do |attribute|
      it "has #{attribute.to_s.humanize.downcase}" do
        value = resource.public_send(attribute)
        expect(subject).to have_jsonapi_attribute(attribute.to_s, value)
      end
    end

    %w(company).each do |relationship|
      it "has #{relationship} relationship" do
        expect(subject).to have_jsonapi_relationship(relationship)
      end
    end

    it 'is valid jsonapi format' do
      expect(subject).to be_jsonapi_formatted('company_images')
    end
  end
end

# == Schema Information
#
# Table name: company_images
#
#  id                        :integer          not null, primary key
#  one_time_token_expires_at :datetime
#  one_time_token            :string
#  company_id                :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  image_file_name           :string
#  image_content_type        :string
#  image_file_size           :integer
#  image_updated_at          :datetime
#
# Indexes
#
#  index_company_images_on_company_id  (company_id)
#
# Foreign Keys
#
#  fk_rails_6dcf524eba  (company_id => companies.id)
#
