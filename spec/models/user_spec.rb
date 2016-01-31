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

  describe 'geocodable' do
    let(:user) { FactoryGirl.create(:user) }

    it 'geocodes by exact address' do
      expect(user.latitude).to eq(55.6997802)
      expect(user.longitude).to eq(13.1953695)
    end

    it 'geocodes by zip' do
      expect(user.zip_latitude).to eq(55.6987817)
      expect(user.zip_longitude).to eq(13.1975525)
    end

    it 'zip lat/long is different from lat/long' do
      expect(user.zip_latitude).not_to eq(user.latitude)
      expect(user.zip_longitude).not_to eq(user.longitude)
    end
  end

  describe '#reset!' do
    it 'resets all personal user attributes' do
      user = FactoryGirl.create(:user)
      old_email = user.email

      user.reset!

      expect(user.name).to eq('Ghost')
      expect(user.email).not_to eq(old_email)
      expect(user.phone).to eq('123456789')
      expect(user.description).to eq('This user has been deleted.')
      expect(user.street).to eq('Stockholm')
      expect(user.zip).to eq('11120')
    end
  end

  describe '#scoped_chats' do
    it 'returns all chats when admin' do
      chat = FactoryGirl.create(:chat)
      admin = FactoryGirl.build(:admin_user)
      expect(admin.scoped_chats).to eq([chat])
    end

    it 'does not return unassociated chats for user' do
      FactoryGirl.create(:chat)
      user = FactoryGirl.build(:user)
      expect(user.scoped_chats).to eq([])
    end

    it 'does return associated chats for user' do
      a_user = FactoryGirl.build(:user)
      user = FactoryGirl.build(:user)
      chat = FactoryGirl.create(:chat, users: [user, a_user])
      expect(user.scoped_chats).to eq([chat])
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
