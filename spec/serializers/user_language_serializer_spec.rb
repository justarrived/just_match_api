# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserLanguageSerializer, type: :serializer do
  context 'Individual Resource Representation' do
    let(:resource) { FactoryGirl.build(:user_language, id: '1') }
    let(:serialization) { JsonApiSerializer.serialize(resource) }

    subject do
      JSON.parse(serialization.to_json)
    end

    %w(language user).each do |relationship|
      it "has #{relationship} relationship" do
        expect(subject).to have_jsonapi_relationship(relationship)
      end
    end

    described_class::ATTRIBUTES.each do |attribute|
      it "has #{attribute.to_s.humanize.downcase}" do
        value = resource.public_send(attribute)
        expect(subject).to have_jsonapi_attribute(attribute.to_s, value)
      end
    end

    it 'is valid jsonapi format' do
      expect(subject).to be_jsonapi_formatted('user_languages')
    end
  end
end

# == Schema Information
#
# Table name: user_languages
#
#  id                   :integer          not null, primary key
#  language_id          :integer
#  user_id              :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  proficiency          :integer
#  proficiency_by_admin :integer
#
# Indexes
#
#  index_user_languages_on_language_id              (language_id)
#  index_user_languages_on_language_id_and_user_id  (language_id,user_id) UNIQUE
#  index_user_languages_on_user_id                  (user_id)
#  index_user_languages_on_user_id_and_language_id  (user_id,language_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_0be39eaff3  (language_id => languages.id)
#  fk_rails_db4f7502c2  (user_id => users.id)
#
