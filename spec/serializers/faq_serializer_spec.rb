# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FaqSerializer, type: :serializer do
  context 'Individual Resource Representation' do
    let(:resource) { FactoryGirl.build(:faq, id: '1') }
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

    it 'is valid jsonapi format' do
      expect(subject).to be_jsonapi_formatted('faqs')
    end
  end
end

# == Schema Information
#
# Table name: faqs
#
#  id          :integer          not null, primary key
#  answer      :text
#  question    :text
#  language_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_faqs_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_...  (language_id => languages.id)
#
