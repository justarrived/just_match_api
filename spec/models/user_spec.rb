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

# == Schema Information
#
# Table name: users
#
#  id            :integer          not null, primary key
#  name          :string
#  email         :string
#  phone         :string
#  description   :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  latitude      :float
#  longitude     :float
#  address       :string
#  language_id   :integer
#  anonymized    :boolean          default(FALSE)
#  auth_token    :string
#  password_hash :string
#  password_salt :string
#  admin         :boolean          default(FALSE)
#
# Indexes
#
#  index_users_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_45f4f12508  (language_id => languages.id)
#
