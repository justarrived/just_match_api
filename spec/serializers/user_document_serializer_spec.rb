# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserDocumentSerializer, type: :serializer do
  context 'Individual Resource Representation' do
    let(:resource) { FactoryGirl.build(:user_document, id: '1') }
    let(:serialization) { JsonApiSerializer.serialize(resource) }

    subject do
      JSON.parse(serialization.to_json)
    end

    it 'has category_name' do
      expect(subject).to have_jsonapi_attribute('category_name', 'cv')
    end

    described_class::ATTRIBUTES.each do |attribute|
      it "has #{attribute.to_s.humanize.downcase}" do
        value = resource.public_send(attribute)
        expect(subject).to have_jsonapi_attribute(attribute.to_s, value)
      end
    end

    %w(user document).each do |relationship|
      it "has #{relationship} relationship" do
        expect(subject).to have_jsonapi_relationship(relationship)
      end
    end

    it 'is valid jsonapi format' do
      expect(subject).to be_jsonapi_formatted('user_documents')
    end
  end
end

# == Schema Information
#
# Table name: user_documents
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  document_id :integer
#  category    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_user_documents_on_document_id  (document_id)
#  index_user_documents_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (document_id => documents.id)
#  fk_rails_...  (user_id => users.id)
#
