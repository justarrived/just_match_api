# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UtalkCodeSerializer, type: :serializer do
  context 'Individual Resource Representation' do
    let(:resource) do
      FactoryBot.build(:utalk_code, id: '1', user: FactoryBot.build(:user, id: 1))
    end
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

    it 'has signup_url attribute' do
      value = resource.signup_url
      expect(subject).to have_jsonapi_attribute('signup_url', value)
    end

    %w(user).each do |relationship|
      it "has #{relationship} relationship" do
        expect(subject).to have_jsonapi_relationship(relationship)
      end
    end

    it 'is valid jsonapi format' do
      expect(subject).to be_jsonapi_formatted('utalk_codes')
    end
  end
end

# == Schema Information
#
# Table name: utalk_codes
#
#  id         :integer          not null, primary key
#  code       :string
#  user_id    :integer
#  claimed_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_utalk_codes_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
