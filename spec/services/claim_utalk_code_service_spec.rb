# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ClaimUtalkCodeService do
  describe ':call' do
    it 'associates the user with a utalk code' do
      FactoryBot.create(:utalk_code, user: nil)
      user = FactoryBot.create(:user)
      utalk_code = nil

      time = Time.zone.now
      Timecop.freeze(time) do
        utalk_code = described_class.call(user: user)
      end

      utalk_code.reload

      expect(utalk_code.user).to eq(user)
      expect(utalk_code.claimed_at.to_date).to eq(time.to_date)
    end

    it 'raises NoUnClaimedUtalkCodeError if no avaialable codes exist' do
      expect do
        described_class.call(user: User.new)
      end.to raise_error(described_class::NoUnClaimedUtalkCodeError)
    end
  end
end
