# frozen_string_literal: true
require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#auth_token' do
    it 'creates a new user with an auth_token of length 32' do
      user = FactoryGirl.build(:user)
      expect(user.auth_token).to be_nil
      user.save!
      expect(user.auth_token.length).to eq(36)
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

      expect(user.name).to eq('Ghost user')
      expect(user.email).not_to eq(old_email)
      expect(user.phone).to eq('123456789')
      expect(user.description).to eq('This user has been deleted.')
      expect(user.street).to eq('Stockholm')
      expect(user.zip).to eq('11120')
    end
  end

  describe '#accepted_applicant_for_owner?' do
    let(:owner) { FactoryGirl.create(:user) }
    let(:user) { FactoryGirl.create(:user) }

    let(:job) { FactoryGirl.create(:job, owner: owner) }

    it 'returns true when user is an accepted applicant for a job owner' do
      allow(JobUser).to receive(:accepted_jobs_for).and_return([job])
      result = User.accepted_applicant_for_owner?(owner: owner, user: user)
      expect(result).to eq(true)
    end

    it 'returns false when user is *not* an accepted applicant for a job owner' do
      result = User.accepted_applicant_for_owner?(owner: owner, user: user)
      expect(result).to eq(false)
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  id            :integer          not null, primary key
#  email         :string
#  phone         :string
#  description   :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  latitude      :float
#  longitude     :float
#  language_id   :integer
#  anonymized    :boolean          default(FALSE)
#  auth_token    :string
#  password_hash :string
#  password_salt :string
#  admin         :boolean          default(FALSE)
#  street        :string
#  zip           :string
#  zip_latitude  :float
#  zip_longitude :float
#  first_name    :string
#  last_name     :string
#
# Indexes
#
#  index_users_on_auth_token   (auth_token) UNIQUE
#  index_users_on_email        (email) UNIQUE
#  index_users_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_45f4f12508  (language_id => languages.id)
#
