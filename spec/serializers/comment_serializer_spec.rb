# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CommentSerializer, type: :serializer do
  context 'Individual Resource Representation' do
    let(:resource) { FactoryGirl.build(:comment, id: '1') }
    let(:serialization) { JsonApiSerializer.serialize(resource) }

    subject do
      JSON.parse(serialization.to_json)
    end

    described_class::ATTRIBUTES.each do |attribute|
      it "has #{attribute.to_s.humanize.downcase}" do
        dashed_attribute = attribute.to_s.dasherize
        value = resource.public_send(attribute)
        expect(subject).to have_jsonapi_attribute(dashed_attribute, value)
      end
    end

    it 'has body_html' do
      dashed_attribute = 'body_html'.dasherize
      expect(subject).to have_jsonapi_attribute(dashed_attribute, nil)
    end

    it 'has translated_text' do
      dashed_attribute = 'translated_text'.dasherize
      value = {
        'body' => nil,
        'body_html'.dasherize => nil,
        'language_id'.dasherize => nil
      }
      expect(subject).to have_jsonapi_attribute(dashed_attribute, value)
    end

    %w(owner language).each do |relationship|
      it "has #{relationship} relationship" do
        expect(subject).to have_jsonapi_relationship(relationship)
      end
    end

    it 'is valid jsonapi format' do
      expect(subject).to be_jsonapi_formatted('comments')
    end
  end
end
# rubocop:disable Metrics/LineLength

# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  body             :text
#  commentable_type :string
#  commentable_id   :integer
#  owner_user_id    :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  language_id      :integer
#  hidden           :boolean          default(FALSE)
#
# Indexes
#
#  index_comments_on_commentable_type_and_commentable_id  (commentable_type,commentable_id)
#  index_comments_on_language_id                          (language_id)
#
# Foreign Keys
#
#  comments_owner_user_id_fk  (owner_user_id => users.id)
#  fk_rails_f55d9b0548        (language_id => languages.id)
#
