# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Job, type: :model do
  describe 'class queries' do
    describe '#matches_user'
  end

  describe 'geocodable' do
    let(:job) { FactoryGirl.create(:job, street: 'Bankgatan 14C', zip: '223 52') }

    it 'geocodes by exact address' do
      expect(job.latitude).to eq(55.6997802)
      expect(job.longitude).to eq(13.1953695)
    end

    it 'geocodes by zip' do
      expect(job.zip_latitude).to eq(55.6987817)
      expect(job.zip_longitude).to eq(13.1975525)
    end

    it 'zip lat/long is different from lat/long' do
      expect(job.zip_latitude).not_to eq(job.latitude)
      expect(job.zip_longitude).not_to eq(job.longitude)
    end
  end

  describe '#owner?' do
    let(:user) { FactoryGirl.build(:user) }
    let(:job) { FactoryGirl.build(:job, owner: user) }

    it 'returns true if user is owner' do
      expect(job.owner?(user)).to eq(true)
    end

    it 'returns true if user is owner' do
      a_user = FactoryGirl.build(:user)
      expect(job.owner?(a_user)).to eq(false)
    end

    it 'returns false if owner is nil and user is not nil' do
      a_user = FactoryGirl.build(:user)
      expect(job.owner?(a_user)).to eq(false)
    end

    it 'returns false if owner is nil and user is nil' do
      expect(job.owner?(nil)).to eq(false)
    end
  end

  describe '#send_performed_accept_notice?' do
    it 'returns true if notice should be sent' do
      job = described_class.new
      job.performed_accept = true
      expected = job.send_performed_accept_notice?
      expect(expected).to eq(true)
    end

    it 'returns false if notice should be sent' do
      job = described_class.new
      job.performed_accept = false
      expected = job.send_performed_accept_notice?
      expect(expected).to eq(false)
    end
  end

  describe '#send_performed_notice?' do
    it 'returns true if notice should be sent' do
      job = described_class.new
      job.performed = true
      expected = job.send_performed_notice?
      expect(expected).to eq(true)
    end

    it 'returns false if notice should be sent' do
      job = described_class.new
      job.performed = false
      expected = job.send_performed_notice?
      expect(expected).to eq(false)
    end
  end

  describe '#accepted_applicant' do
    it 'returns nil if no accepted applicant' do
      job = described_class.new
      expect(job.accepted_applicant).to eq(nil)
    end

    it 'returns accepted user if no job user' do
      applicant = FactoryGirl.create(:user)
      owner = FactoryGirl.create(:user)
      job = FactoryGirl.create(:job, owner: owner)

      job.create_applicant!(applicant)
      job.accept_applicant!(applicant)

      expect(job.accepted_applicant).to eq(applicant)
    end
  end

  describe '#accept_applicant?' do
    it 'returns false if user is *not* the accepted user' do
      job = described_class.new
      user = FactoryGirl.build(:user)
      expect(job.accepted_applicant?(user)).to eq(false)
    end

    it 'returns true if user is the accepted user' do
      applicant = FactoryGirl.create(:user)
      owner = FactoryGirl.create(:user)
      job = FactoryGirl.create(:job, owner: owner)

      job.create_applicant!(applicant)
      job.accept_applicant!(applicant)

      expect(job.accepted_applicant?(applicant)).to eq(true)
    end

    it 'returns false if owner is nil and user is not' do
      nil_job = Job.new
      a_user = FactoryGirl.build(:user)
      expect(nil_job.accepted_applicant?(a_user)).to eq(false)
    end

    it 'returns false if owner is nil and user is nil' do
      nil_job = Job.new
      expect(nil_job.accepted_applicant?(nil)).to eq(false)
    end
  end
end

# == Schema Information
#
# Table name: jobs
#
#  id               :integer          not null, primary key
#  max_rate         :integer
#  description      :text
#  job_date         :datetime
#  performed_accept :boolean          default(FALSE)
#  performed        :boolean          default(FALSE)
#  hours            :float
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  owner_user_id    :integer
#  latitude         :float
#  longitude        :float
#  name             :string
#  language_id      :integer
#  street           :string
#  zip              :string
#  zip_latitude     :float
#  zip_longitude    :float
#
# Indexes
#
#  index_jobs_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_70cb33aa57    (language_id => languages.id)
#  jobs_owner_user_id_fk  (owner_user_id => users.id)
#
