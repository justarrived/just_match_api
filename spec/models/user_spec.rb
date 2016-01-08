require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#auth_token' do
    it 'creates a new user with an auth_token of length 32' do
      user = FactoryGirl.build(:user)
      expect(user.auth_token).to be_nil
      user.save!
      expect(user.auth_token.length).to eq(32)
    end
  end
end
