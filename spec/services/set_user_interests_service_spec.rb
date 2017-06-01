# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SetUserInterestsService do
  describe '::call' do
    let(:user) { FactoryGirl.create(:user) }
    let(:interest) { FactoryGirl.create(:interest) }
    let(:level) { 4 }
    let(:interest_param) do
      [{ id: interest.id, level: level }]
    end

    it 'set user interests' do
      expect(user.user_interests).to be_empty
      described_class.call(user: user, interest_ids_param: interest_param)
      expect(user.user_interests.first.level).to eq(4)
      expect(user.user_interests.length).to eq(1)
    end
  end
end
