# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserOccupationSerializer, type: :serializer do
  context 'Individual Resource Representation' do
    let(:resource) { FactoryBot.build(:user_occupation, id: '1') }
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

    %w(user occupation).each do |relationship|
      it "has #{relationship} relationship" do
        expect(subject).to have_jsonapi_relationship(relationship)
      end
    end

    it 'is valid jsonapi format' do
      expect(subject).to be_jsonapi_formatted('user_occupations')
    end
  end
end

# == Schema Information
#
# Table name: user_occupations
#
#  id                  :integer          not null, primary key
#  occupation_id       :integer
#  user_id             :integer
#  years_of_experience :integer
#  importance          :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_user_occupations_on_occupation_id  (occupation_id)
#  index_user_occupations_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (occupation_id => occupations.id)
#  fk_rails_...  (user_id => users.id)
#
