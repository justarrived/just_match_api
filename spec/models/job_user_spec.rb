# frozen_string_literal: true
require 'rails_helper'

RSpec.describe JobUser, type: :model do
  it 'has MAX_CONFIRMATION_TIME_HOURS constant that is 18' do
    expect(JobUser::MAX_CONFIRMATION_TIME_HOURS).to eq(18)
  end

  describe '#applicant_confirmation_overdue?' do
    it 'returns true if overdue' do
      hours_ago = (JobUser::MAX_CONFIRMATION_TIME_HOURS + 1).hours.ago
      job_user = FactoryGirl.build(:job_user, accepted: true, accepted_at: hours_ago)
      expect(job_user.applicant_confirmation_overdue?).to eq(true)
    end

    it 'returns false if *not* overdue' do
      hours_ago = (JobUser::MAX_CONFIRMATION_TIME_HOURS - 1).hours.ago
      job_user = FactoryGirl.build(:job_user, accepted: true, accepted_at: hours_ago)
      expect(job_user.applicant_confirmation_overdue?).to eq(false)
    end

    it 'returns false if accepted_at is nil' do
      job_user = FactoryGirl.build(:job_user)
      expect(job_user.applicant_confirmation_overdue?).to eq(false)
    end
  end

  describe '#accepted_jobs_for' do
    let(:job_user) { FactoryGirl.create(:job_user) }

    it 'returns all jobs where user is accepted' do
      job_user.accept
      job_user.save
      accepted_jobs = described_class.accepted_jobs_for(job_user.user)
      expect(accepted_jobs).to include(job_user.job)
    end

    it 'does not return jobs where is *not* accepted' do
      accepted_jobs = described_class.accepted_jobs_for(job_user.user)
      expect(accepted_jobs).to_not include(job_user.job)
    end
  end

  describe '#accepted_at_setter' do
    let(:job_user) { described_class.new }

    it 'adds accepted_date if accepted is changed to true' do
      time = Time.zone.now
      Timecop.freeze(time) do
        job_user.accepted = true
        job_user.validate
        expect(job_user.accepted_at).to eq(time)
      end
    end

    it 'does *not* add accepted_date if accepted is not changed to true' do
      job_user.accepted = false
      job_user.validate
      result = job_user.accepted_at
      expect(result).to be_nil
    end
  end

  describe '#send_accepted_notice?' do
    let(:job_user) { described_class.new }

    it 'returns true if notice should be sent' do
      job_user.accepted = true
      result = job_user.send_accepted_notice?
      expect(result).to eq(true)
    end

    it 'returns false if notice should be sent' do
      job_user.accepted = false
      result = job_user.send_accepted_notice?
      expect(result).to eq(false)
    end
  end

  describe '#send_performed_accepted_notice?' do
    it 'returns true if notice should be sent' do
      job = described_class.new
      job.performed_accepted = true
      expected = job.send_performed_accepted_notice?
      expect(expected).to eq(true)
    end

    it 'returns false if notice should be sent' do
      job = described_class.new
      job.performed_accepted = false
      expected = job.send_performed_accepted_notice?
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

  it 'validates uniqueness of {job|user} scope' do
    user = FactoryGirl.build(:user)
    job = FactoryGirl.build(:job)
    FactoryGirl.create(:job_user, user: user, job: job)

    job_user = FactoryGirl.build(:job_user, user: user, job: job)
    job_user.validate

    messages = job_user.errors.messages
    [:user, :job].each do |err_type|
      result = messages[err_type]
      expect(result).to eq(['has already been taken'])
    end
  end

  it 'validates user not owner of job' do
    job = FactoryGirl.create(:job)
    job_owner = job.owner

    job_user = FactoryGirl.build(:job_user, user: job_owner, job: job)
    job_user.validate

    message = job_user.errors.messages[:user]
    expect(message).to eq(["can't be both job owner and job applicant"])
  end

  it 'validates only one applicant' do
    job = FactoryGirl.create(:job)
    user = FactoryGirl.create(:user)

    FactoryGirl.create(:job_user, job: job, accepted: true)

    job_user = FactoryGirl.create(:job_user, user: user, job: job)
    job_user.validate

    message = job_user.errors.messages[:multiple_applicants]
    expect(message).to eq(["can't accept multiple applicants for job"])
  end

  describe '#send_will_perform_notice?' do
    let(:job_user) { FactoryGirl.build(:job_user) }

    it 'returns false when it should *not* send notice' do
      expect(job_user.send_will_perform_notice?).to eq(false)
    end

    it 'returns true when it should send notice' do
      job_user.will_perform = true
      expect(job_user.send_will_perform_notice?).to eq(true)
    end
  end

  describe '#send_accepted_notice?' do
    let(:job_user) { FactoryGirl.build(:job_user) }

    it 'returns false when it should *not* send notice' do
      expect(job_user.send_accepted_notice?).to eq(false)
    end

    it 'returns true when it should send notice' do
      job_user.accepted = true
      expect(job_user.send_accepted_notice?).to eq(true)
    end
  end

  describe 'validate will perform not reverted' do
    let(:job_user) { FactoryGirl.build(:job_user_accepted) }

    it 'adds *no* error when value is already false' do
      job_user.validate
      expect(job_user.errors.messages[:will_perform]).to eq(nil)
    end

    it 'adds error when value is true and set to false' do
      job_user.will_perform = true
      job_user.save!
      job_user.will_perform = false
      job_user.validate
      err_msg = I18n.t('errors.validators.unrevertable')
      expect(job_user.errors.messages[:will_perform]).to include(err_msg)
    end
  end

  describe 'validate accepted not reverted' do
    let(:job_user) { FactoryGirl.build(:job_user) }

    it 'adds *no* error when value is already false' do
      job_user.validate
      expect(job_user.errors.messages[:accepted]).to eq(nil)
    end

    it 'adds error when value is true and set to false' do
      job_user.accepted = true
      job_user.save!
      job_user.accepted = false
      job_user.validate
      err_msg = I18n.t('errors.validators.unrevertable')
      expect(job_user.errors.messages[:accepted]).to include(err_msg)
    end

    it 'adds *no* error when value is true and set to false if confirmation overdue' do
      job_user.accepted = true
      job_user.save!
      job_user.accepted_at = (JobUser::MAX_CONFIRMATION_TIME_HOURS + 1).hours.ago
      job_user.accepted = false
      job_user.validate
      expect(job_user.errors.messages[:accepted]).to eq(nil)
    end
  end

  describe 'validate performed not reverted' do
    let(:job_user) { FactoryGirl.build(:job_user_will_perform) }

    it 'adds *no* error when value is already false' do
      job_user.validate
      expect(job_user.errors.messages[:performed]).to eq(nil)
    end

    it 'adds error when value is true and set to false' do
      job_user.performed = true
      job_user.save!
      job_user.performed = false
      job_user.validate
      err_msg = I18n.t('errors.validators.unrevertable')
      expect(job_user.errors.messages[:performed]).to include(err_msg)
    end
  end

  describe 'validate performed accepted not reverted' do
    let(:job_user) { FactoryGirl.build(:job_user_will_perform) }

    it 'adds *no* error when value is already false' do
      job_user.validate
      expect(job_user.errors.messages[:performed_accepted]).to eq(nil)
    end

    it 'adds error when value is true and set to false' do
      job_user.performed_accepted = true
      job_user.save!
      job_user.performed_accepted = false
      job_user.validate
      err_msg = I18n.t('errors.validators.unrevertable')
      expect(job_user.errors.messages[:performed_accepted]).to include(err_msg)
    end
  end

  describe 'validate accepted before will perform' do
    let(:job_user) { FactoryGirl.build(:job_user) }

    it 'adds error if already accepted is false' do
      job_user.will_perform = true
      job_user.validate
      err_msg = I18n.t('errors.validators.after_true', field: 'accepted')
      expect(job_user.errors.messages[:will_perform]).to include(err_msg)
    end

    it 'adds *no* error if already accepted' do
      job_user.will_perform = true
      job_user.accepted = true
      job_user.validate
      expect(job_user.errors.messages[:will_perform]).to eq(nil)
    end
  end

  describe 'validate will perform before performed' do
    let(:job_user) { FactoryGirl.build(:job_user) }

    it 'adds error if will_perform is false' do
      job_user.performed = true
      job_user.validate
      err_msg = I18n.t('errors.validators.after_true', field: 'will perform')
      expect(job_user.errors.messages[:performed]).to include(err_msg)
    end

    it 'adds *no* error if will perform is true' do
      job_user.performed = true
      job_user.will_perform = true
      job_user.validate
      expect(job_user.errors.messages[:performed]).to eq(nil)
    end
  end

  describe 'validate will perform before performed accepted' do
    let(:job_user) { FactoryGirl.build(:job_user) }

    it 'adds error if will_perform is false' do
      job_user.performed_accepted = true
      job_user.validate
      err_msg = I18n.t('errors.validators.after_true', field: 'will perform')
      expect(job_user.errors.messages[:performed_accepted]).to include(err_msg)
    end

    it 'adds *no* error if will perform is true' do
      job_user.performed_accepted = true
      job_user.will_perform = true
      job_user.validate
      expect(job_user.errors.messages[:performed_accepted]).to eq(nil)
    end
  end

  describe '#validate_passed_job_date_before_performed' do
    let(:passed_job) { FactoryGirl.build(:job, job_date: 2.weeks.ago) }
    let(:inprogress_job) do
      time = Time.zone.now - 1.hour
      FactoryGirl.build(:job, job_date: time, hours: 2)
    end

    it 'adds error if the job is *not* yet over' do
      job_user = FactoryGirl.build(:job_user, job: inprogress_job)
      job_user.performed = true
      job_user.will_perform = true
      job_user.validate
      message = I18n.t('errors.job_user.performed_before_job_over')
      expect(job_user.errors.messages[:performed]).to include(message)
    end

    it 'adds *no* error if the job is over' do
      job_user = FactoryGirl.build(:job_user, job: passed_job)
      job_user.performed = true
      job_user.will_perform = true
      job_user.validate
      expect(job_user.errors.messages[:performed]).to eq(nil)
    end
  end

  describe '#validate_passed_job_date_before_performed_accepted' do
    let(:passed_job) { FactoryGirl.build(:job) }
    let(:inprogress_job) { FactoryGirl.build(:inprogress_job) }
    let(:future_job) { FactoryGirl.build(:future_job) }

    it 'adds error if the job is in the future' do
      job_user = FactoryGirl.build(:job_user, job: future_job)
      job_user.performed_accepted = true
      job_user.will_perform = true
      job_user.validate
      message = I18n.t('errors.job_user.performed_accepted_before_job_over')
      expect(job_user.errors.messages[:performed_accepted]).to include(message)
    end

    it 'adds error if the job is in progress' do
      job_user = FactoryGirl.build(:job_user, job: inprogress_job)
      job_user.performed_accepted = true
      job_user.will_perform = true
      job_user.validate
      message = I18n.t('errors.job_user.performed_accepted_before_job_over')
      expect(job_user.errors.messages[:performed_accepted]).to include(message)
    end

    it 'adds *no* error if the job is over' do
      job_user = FactoryGirl.build(:job_user, job: passed_job)
      job_user.performed_accepted = true
      job_user.will_perform = true
      job_user.validate
      expect(job_user.errors.messages[:performed_accepted]).to eq(nil)
    end
  end
end

# == Schema Information
#
# Table name: job_users
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  job_id             :integer
#  accepted           :boolean          default(FALSE)
#  rate               :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  will_perform       :boolean          default(FALSE)
#  accepted_at        :datetime
#  performed          :boolean          default(FALSE)
#  performed_accepted :boolean          default(FALSE)
#
# Indexes
#
#  index_job_users_on_job_id              (job_id)
#  index_job_users_on_job_id_and_user_id  (job_id,user_id) UNIQUE
#  index_job_users_on_user_id             (user_id)
#  index_job_users_on_user_id_and_job_id  (user_id,job_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_548d2d3ba9  (job_id => jobs.id)
#  fk_rails_815844930e  (user_id => users.id)
#
