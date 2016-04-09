# frozen_string_literal: true
require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#auth_token' do
    it 'creates a new user with an auth_token of length 36' do
      user = FactoryGirl.create(:user)
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
      expect(user.ssn).to eq('0000000000')
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

  describe '#locale' do
    it 'returns en for a non-persisted user that has no language' do
      expect(User.new.locale).to eq('en')
    end

    it 'returns correct locale for user that has a language' do
      lang_code = 'wa'
      language = FactoryGirl.build(:language, lang_code: lang_code)
      user = FactoryGirl.build(:user, language: language)
      expect(user.locale).to eq(lang_code)
    end
  end

  describe 'banned' do
    let(:user) { FactoryGirl.create(:user) }

    it 'generates a new auth_token when user is banned' do
      token = user.auth_token
      user.banned = true
      user.save
      expect(user.auth_token).not_to eq(token)
      expect(user.banned).to eq(true)
    end
  end

  describe '#valid_password?' do
    it 'returns true if password is at least of length 6' do
      expect(User.valid_password?('123456')).to eq(true)
    end

    it 'returns false if password is at less than 6 in length' do
      expect(User.valid_password?('12345')).to eq(false)
    end

    it 'returns false if password is *not* a string' do
      expect(User.valid_password?(%w(1 2 3 4 5 6))).to eq(false)
      expect(User.valid_password?(a: 2)).to eq(false)
    end

    it 'returns false if password is blank' do
      expect(User.valid_password?('')).to eq(false)
      expect(User.valid_password?(nil)).to eq(false)
    end
  end

  it 'has a one time token validity constant that is 18' do
    expect(User::ONE_TIME_TOKEN_VALID_FOR_HOURS).to eq(18)
  end

  it 'has a min password length constant that is 6' do
    expect(User::MIN_PASSWORD_LENGTH).to eq(6)
  end

  describe '#generate_one_time_token' do
    let(:user) { FactoryGirl.build(:user) }

    it 'generates one time token' do
      user.generate_one_time_token
      expect(user.one_time_token.length).to eq(36)
    end

    it 'generates one time token expiry datetime' do
      time = Time.zone.now
      validity_time = User::ONE_TIME_TOKEN_VALID_FOR_HOURS.hours
      Timecop.freeze(time) do
        user.generate_one_time_token
        expect(user.one_time_token_expires_at).to eq(time + validity_time)
      end
    end
  end

  describe '#find_by_one_time_token' do
    context 'token still valid' do
      it 'finds and returns user' do
        user = FactoryGirl.create(:user)
        user.generate_one_time_token
        user.save!

        token = user.one_time_token
        expect(User.find_by_one_time_token(token)).to eq(user)
      end
    end

    context 'token expired' do
      it 'returns nil' do
        user = FactoryGirl.create(:user)
        user.generate_one_time_token
        user.save!

        token = user.one_time_token
        Timecop.freeze(Time.zone.today + 30) do
          expect(User.find_by_one_time_token(token)).to be_nil
        end
      end
    end
  end

  describe 'notifications' do
    context 'constant' do
      it 'has the correct elements' do
        expected = %w(
          accepted_applicant_confirmation_overdue
          accepted_applicant_withdrawn
          applicant_accepted
          applicant_will_perform
          job_user_performed_accepted
          job_user_performed
          new_applicant
          user_job_match
        )
        expect(User::NOTIFICATIONS).to eq(expected)
      end

      it 'has corresponding notifier klass for each item' do
        User::NOTIFICATIONS.each do |notifications|
          expect { "#{notifications.camelize}Notifier".constantize }.to_not raise_error
        end
      end
    end

    describe '#ignored_notification?' do
      it 'returns true when is ignored' do
        ignored = 'new_applicant'
        user = FactoryGirl.build(:user, ignored_notifications: [ignored])
        expect(user.ignored_notification?(ignored)).to eq(true)
      end

      it 'returns false when *not* ignored' do
        user = FactoryGirl.build(:user)
        expect(user.ignored_notification?('new_applicant')).to eq(false)
      end
    end

    it 'can set mask' do
      ignored = %w(new_applicant)
      user = FactoryGirl.build(:user, ignored_notifications: ignored)
      expect(user.ignored_notifications).to eq(ignored)
    end

    it 'can set default mask' do
      user = FactoryGirl.build(:user)
      expect(user.ignored_notifications).to eq([])
    end
  end

  describe '#validate_language_id_in_available_locale' do
    it 'adds error if language is not in available locale' do
      language = FactoryGirl.create(:language, lang_code: 'aa')
      user = FactoryGirl.build(:user, language: language)
      user.validate

      message = user.errors.messages[:language_id]
      expect(message).to include(I18n.t('errors.user.must_be_available_locale'))
    end

    it 'adds *no* error if language is not in available locale' do
      language = FactoryGirl.create(:language, lang_code: 'en')
      user = FactoryGirl.build(:user, language: language)
      user.validate

      message = user.errors.messages[:language_id]
      expect(message || []).not_to include(I18n.t('errors.user.must_be_available_locale'))
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  id                         :integer          not null, primary key
#  email                      :string
#  phone                      :string
#  description                :text
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  latitude                   :float
#  longitude                  :float
#  language_id                :integer
#  anonymized                 :boolean          default(FALSE)
#  auth_token                 :string
#  password_hash              :string
#  password_salt              :string
#  admin                      :boolean          default(FALSE)
#  street                     :string
#  zip                        :string
#  zip_latitude               :float
#  zip_longitude              :float
#  first_name                 :string
#  last_name                  :string
#  ssn                        :string
#  company_id                 :integer
#  banned                     :boolean          default(FALSE)
#  job_experience             :text
#  education                  :text
#  one_time_token             :string
#  one_time_token_expires_at  :datetime
#  ignored_notifications_mask :integer
#
# Indexes
#
#  index_users_on_auth_token      (auth_token) UNIQUE
#  index_users_on_company_id      (company_id)
#  index_users_on_email           (email) UNIQUE
#  index_users_on_language_id     (language_id)
#  index_users_on_one_time_token  (one_time_token) UNIQUE
#  index_users_on_ssn             (ssn) UNIQUE
#
# Foreign Keys
#
#  fk_rails_45f4f12508  (language_id => languages.id)
#  fk_rails_7682a3bdfe  (company_id => companies.id)
#
