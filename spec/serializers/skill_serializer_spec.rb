# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SkillSerializer, type: :serializer do
  context 'Individual Resource Representation' do
    let(:resource) { FactoryBot.build(:skill, id: '1') }
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

    %w(language).each do |relationship|
      it "has #{relationship} relationship" do
        expect(subject).to have_jsonapi_relationship(relationship)
      end
    end

    it 'is valid jsonapi format' do
      expect(subject).to be_jsonapi_formatted('skills')
    end
  end
end

# == Schema Information
#
# Table name: skills
#
#  id            :integer          not null, primary key
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  language_id   :integer
#  internal      :boolean          default(FALSE)
#  color         :string
#  high_priority :boolean          default(FALSE)
#
# Indexes
#
#  index_skills_on_language_id  (language_id)
#  index_skills_on_name         (name) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (language_id => languages.id)
#
