# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobDigest, type: :model do
  describe '#coordinates?' do
    it 'returns false if job digest has *no* address' do
      job_digest = FactoryGirl.build_stubbed(:job_digest, address: nil)
      expect(job_digest.coordinates?).to eq(false)
    end

    it 'returns false if job digest address has *no* coordinates' do
      address = FactoryGirl.build_stubbed(:address, latitude: nil, longitude: nil)
      job_digest = FactoryGirl.build_stubbed(:job_digest, address: address)
      expect(job_digest.coordinates?).to eq(false)
    end

    it 'returns true if job digest address has coordinates' do
      address = FactoryGirl.build_stubbed(:address, latitude: 13, longitude: 13)
      job_digest = FactoryGirl.build_stubbed(:job_digest, address: address)
      expect(job_digest.coordinates?).to eq(true)
    end
  end
end

# == Schema Information
#
# Table name: job_digests
#
#  id                     :integer          not null, primary key
#  address_id             :integer
#  notification_frequency :integer
#  max_distance           :float
#  locale                 :string(10)
#  digest_subscriber_id   :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_job_digests_on_address_id            (address_id)
#  index_job_digests_on_digest_subscriber_id  (digest_subscriber_id)
#
# Foreign Keys
#
#  fk_rails_...  (address_id => addresses.id)
#  fk_rails_...  (digest_subscriber_id => digest_subscribers.id)
#
