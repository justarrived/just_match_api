# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobDigest, type: :model do
  describe '#coordinates?' do
    it 'returns false if job digest has *no* address' do
      job_digest = FactoryGirl.build_stubbed(:job_digest, addresses: [])
      expect(job_digest.coordinates?).to eq(false)
    end

    it 'returns false if job digest address has *no* coordinates' do
      address = FactoryGirl.build_stubbed(:address, latitude: nil, longitude: nil)
      job_digest = FactoryGirl.build_stubbed(:job_digest, addresses: [address])
      expect(job_digest.coordinates?).to eq(false)
    end

    it 'returns true if job digest address has coordinates' do
      address = FactoryGirl.build_stubbed(:address, latitude: 13, longitude: 13)
      job_digest = FactoryGirl.build_stubbed(:job_digest, addresses: [address])
      expect(job_digest.coordinates?).to eq(true)
    end
  end

  describe '#soft_destroy!' do
    it 'sets #deleted_at to the current time' do
      time = Time.zone.now
      Timecop.freeze(time) do
        digest = FactoryGirl.create(:job_digest)
        digest.soft_destroy!

        expect(digest.deleted_at).to eq(time)
      end
    end
  end

  describe '#set_locale' do
    it 'sets locale to the default locale unless present' do
      expect(described_class.new.tap(&:validate).locale).to eq(I18n.locale.to_s)
    end

    it 'does not override locale if present' do
      expect(described_class.new(locale: :ar).tap(&:validate).locale).to eq('ar')
    end
  end

  describe '#set_max_distance' do
    it 'sets max_distance to the default max distance unless present' do
      expected = JobDigest::DEFAULT_MAX_DISTANCE
      expect(described_class.new.tap(&:validate).max_distance).to eq(expected)
    end

    it 'does not override max_distance if present' do
      expect(described_class.new(max_distance: 1).tap(&:validate).max_distance).to eq(1)
    end
  end

  context 'with non-persisted, invalid subscriber' do
    it 'returns error' do
      digest = described_class.new(subscriber: DigestSubscriber.new)
      digest.validate

      expect(digest.errors[:subscriber]).not_to be_empty
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
#  deleted_at             :datetime
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
