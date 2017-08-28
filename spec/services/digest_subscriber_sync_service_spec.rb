# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DigestSubscriberSyncService do
  describe '::call' do
    it 'returns empty array if there are no previous subscribers connected' do
      user = FactoryGirl.create(:user)
      expect(described_class.call(user: user)).to eq([])
    end

    it 'returns array of DigestSubscriber:s if there are existing subscribtions' do
      email = 'watman-jbs-service@example.com'
      subscriber = FactoryGirl.create(:digest_subscriber, email: email)
      user = FactoryGirl.create(:user, email: email)
      result = described_class.call(user: user)
      expect(result).to match([subscriber])
      expect(result.first.email).to be_nil
      expect(result.first.user).to eq(user)
    end
  end
end
