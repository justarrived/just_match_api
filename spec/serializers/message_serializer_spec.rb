# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MessageSerializer, type: :serializer do
  context 'Individual Resource Representation' do
    let(:resource) { FactoryGirl.build(:message, id: '1') }
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

    it 'has body_html' do
      expect(subject).to have_jsonapi_attribute('body_html', nil)
    end

    it 'has translated_text' do
      value = {
        'body' => nil,
        'body_html' => nil,
        'language_id' => nil
      }
      expect(subject).to have_jsonapi_attribute('translated_text', value)
    end

    %w(chat author language).each do |relationship|
      it "has #{relationship} relationship" do
        expect(subject).to have_jsonapi_relationship(relationship)
      end
    end

    it 'is valid jsonapi format' do
      expect(subject).to be_jsonapi_formatted('messages')
    end
  end
end

# == Schema Information
#
# Table name: messages
#
#  id          :integer          not null, primary key
#  chat_id     :integer
#  author_id   :integer
#  integer     :integer
#  language_id :integer
#  body        :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_messages_on_chat_id      (chat_id)
#  index_messages_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_...           (chat_id => chats.id)
#  fk_rails_...           (language_id => languages.id)
#  messages_author_id_fk  (author_id => users.id)
#
