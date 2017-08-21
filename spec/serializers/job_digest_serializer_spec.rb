# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobDigestSerializer, type: :serializer do
  context 'Individual Resource Representation' do
    let(:resource) { FactoryGirl.build(:job_digest, id: '1') }
    let(:serialization) { JsonApiSerializer.serialize(resource) }

    subject do
      JSON.parse(serialization.to_json)
    end

    %i(city notification_frequency).each do |attribute|
      it "has #{attribute.to_s.humanize.downcase}" do
        value = resource.public_send(attribute)
        expect(subject).to have_jsonapi_attribute(attribute.to_s, value)
      end
    end

    %w(job_digest_subscriber).each do |relationship|
      it "has #{relationship} relationship" do
        expect(subject).to have_jsonapi_relationship(relationship)
      end
    end

    it 'is valid jsonapi format' do
      expect(subject).to be_jsonapi_formatted('job_digests')
    end
  end
end

# == Schema Information
#
# Table name: job_digests
#
#  id                       :integer          not null, primary key
#  city                     :string
#  notification_frequency   :integer
#  job_digest_subscriber_id :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
# Indexes
#
#  index_job_digests_on_job_digest_subscriber_id  (job_digest_subscriber_id)
#
# Foreign Keys
#
#  fk_rails_...  (job_digest_subscriber_id => job_digest_subscribers.id)
#