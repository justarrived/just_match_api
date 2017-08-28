# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DigestSubscriberSerializer, type: :serializer do
  context 'Individual Resource Representation' do
    let(:resource) { FactoryGirl.build(:digest_subscriber, id: '1') }
    let(:serialization) { JsonApiSerializer.serialize(resource) }

    subject do
      JSON.parse(serialization.to_json)
    end

    %i(email uuid).each do |attribute|
      it "has #{attribute.to_s.humanize.downcase}" do
        value = resource.public_send(attribute)
        expect(subject).to have_jsonapi_attribute(attribute.to_s, value)
      end
    end

    %w(job_digests).each do |relationship|
      it "has #{relationship} relationship" do
        expect(subject).to have_jsonapi_relationship(relationship)
      end
    end

    it 'is valid jsonapi format' do
      expect(subject).to be_jsonapi_formatted('digest_subscribers')
    end
  end
end

# == Schema Information
#
# Table name: digest_subscribers
#
#  id         :integer          not null, primary key
#  email      :string
#  uuid       :string(36)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_digest_subscribers_on_user_id  (user_id)
#  index_digest_subscribers_on_uuid     (uuid) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
