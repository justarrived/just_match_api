# frozen_string_literal: true
require 'rails_helper'

RSpec.describe UserImageSerializer, type: :serializer do
  context 'Individual Resource Representation' do
    let(:resource) { FactoryGirl.build(:user_image) }
    let(:serialization) { JsonApiSerializer.serialize(resource) }

    subject do
      JSON.parse(serialization.to_json)
    end

    it 'has image-url' do
      value = resource.image.url
      expect(subject).to have_jsonapi_attribute('image-url', value)
    end

    it 'has image-url-large' do
      value = resource.image.url(:large)
      expect(subject).to have_jsonapi_attribute('image-url-large', value)
    end

    it 'has image-url-medium' do
      value = resource.image.url(:medium)
      expect(subject).to have_jsonapi_attribute('image-url-medium', value)
    end

    it 'has image-url-small' do
      value = resource.image.url(:small)
      expect(subject).to have_jsonapi_attribute('image-url-small', value)
    end

    described_class::ATTRIBUTES.each do |attribute|
      it "has #{attribute.to_s.humanize.downcase}" do
        dashed_attribute = attribute.to_s.dasherize
        value = resource.public_send(attribute)
        expect(subject).to have_jsonapi_attribute(dashed_attribute, value)
      end
    end

    %w(user).each do |relationship|
      it "has #{relationship} relationship" do
        expect(subject).to have_jsonapi_relationship(relationship)
      end
    end

    it 'is valid jsonapi format' do
      expect(subject).to be_jsonapi_formatted('user-images')
    end
  end
end
