# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GuideSectionArticleSerializer, type: :serializer do
  context 'Individual Resource Representation' do
    let(:resource) { FactoryGirl.build(:guide_section_article, id: '1') }
    let(:serialization) { JsonApiSerializer.serialize(resource) }

    subject do
      JSON.parse(serialization.to_json)
    end

    described_class::ATTRIBUTES.each do |attribute|
      it "has #{attribute.to_s.humanize.downcase}" do
        value = resource.public_send(attribute)
        expect(subject).to have_jsonapi_attribute(attribute.to_s, value)
      end
    end

    it 'has translated text' do
      value = {
        'title' => nil,
        'slug' => nil,
        'short_description' => nil,
        'body' => nil,
        'language_id' => nil
      }
      expect(subject).to have_jsonapi_attribute('translated_text', value)
    end

    %w(language section).each do |relationship|
      it "has #{relationship} relationship" do
        expect(subject).to have_jsonapi_relationship(relationship)
      end
    end

    it 'is valid jsonapi format' do
      expect(subject).to be_jsonapi_formatted('guide_section_articles')
    end
  end
end
