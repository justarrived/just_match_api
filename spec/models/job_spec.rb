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

  describe '#locked_for_changes?' do
    let(:job) { FactoryGirl.create(:job) }

    it 'returns false when there is no accepted applicant' do
      expect(job.locked_for_changes?).to eq(false)
    end

    it 'returns false when there is an accepted applicant, but has *not* confirmed' do
      FactoryGirl.create(:job_user, job: job, accepted: true)
      expect(job.locked_for_changes?).to eq(false)
    end

    it 'returns true when there is an accepted applicant, that has confirmed' do
      FactoryGirl.create(:job_user, job: job, accepted: true, will_perform: true)
      expect(job.locked_for_changes?).to eq(true)
    end
  end

  describe '#started?' do
    it 'returns true for an inprogress job' do
      job = FactoryGirl.build(:inprogress_job)
      expect(job.started?).to eq(true)
    end

    it 'returns false for a future job' do
      job = FactoryGirl.build(:future_job)
      expect(job.started?).to eq(false)
    end

    it 'returns true for a passed job' do
      job = FactoryGirl.build(:passed_job)
      expect(job.started?).to eq(true)
    end
  end

  describe '#validate_job_date_in_future' do
    it 'adds error if the job_date is in the passed' do
      job = FactoryGirl.build(:job, job_date: 1.day.ago)
      job.validate
      message = I18n.t('errors.job.job_date_in_the_past')
      expect(job.errors.messages[:job_date]).to include(message)
    end

    it 'adds *no* error if the job_date is nil' do
      job = FactoryGirl.build(:job, job_date: nil)
      job.validate
      message = I18n.t('errors.job.job_date_in_the_past')
      expect(job.errors.messages[:job_date]).not_to include(message)
    end

    it 'adds *no* error if the job_date is in the future' do
      job = FactoryGirl.build(:job, job_date: 1.week.from_now)
      job.validate
      message = I18n.t('errors.job.job_date_in_the_past')
      expect(job.errors.messages[:job_date] || []).not_to include(message)
    end
  end
end

# == Schema Information
#
# Table name: jobs
#
#  id            :integer          not null, primary key
#  max_rate      :integer
#  description   :text
#  job_date      :datetime
#  hours         :float
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  owner_user_id :integer
#  latitude      :float
#  longitude     :float
#  language_id   :integer
#  street        :string
#  zip           :string
#  zip_latitude  :float
#  zip_longitude :float
#  hidden        :boolean          default(FALSE)
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
