# frozen_string_literal: true
require 'rails_helper'

RSpec.describe JobUser, type: :model do
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

  %w(accepted will_perform).each do |column|
    notice_method_name = "send_#{column}_notice?"
    describe "##{notice_method_name}" do
      let(:job_user) { FactoryGirl.build(:job_user) }

      it 'returns false when it should *not* send notice' do
        expect(job_user.public_send(notice_method_name)).to eq(false)
      end

      it 'returns true when it should send notice' do
        job_user.public_send("#{column}=", true)
        expect(job_user.public_send(notice_method_name)).to eq(true)
      end
    end

    describe "#validate_#{column}_attribute" do
      let(:job_user) { FactoryGirl.build(:job_user) }

      it 'adds *no* error when value is already false' do
        job_user.validate
        expect(job_user.errors.messages[column.to_sym]).to eq(nil)
      end

      it 'adds error when value is true and set to false' do
        # Must explicitly be set accepted to true here otherwise #save! will raises an
        #  error, since #will_perform requires accepted to be true in order to be set
        job_user.accepted = true
        job_user.public_send("#{column}=", true)
        job_user.save!
        job_user.public_send("#{column}=", false)
        job_user.validate
        err_msg = "can't change to false if already true"
        expect(job_user.errors.messages[column.to_sym]).to include(err_msg)
      end
    end
  end

  describe '#validate_accepted_before_will_perform' do
    let(:job_user) { FactoryGirl.build(:job_user) }

    it 'adds error if already accepted is false' do
      job_user.will_perform = true
      job_user.validate
      err_msg = 'must be accepted to confirm will perform'
      expect(job_user.errors.messages[:will_perform]).to include(err_msg)
    end

    it 'adds *no* error if already accepted' do
      job_user.will_perform = true
      job_user.accepted = true
      job_user.validate
      expect(job_user.errors.messages[:will_perform]).to eq(nil)
    end
  end
end

# == Schema Information
#
# Table name: job_users
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  job_id       :integer
#  accepted     :boolean          default(FALSE)
#  rate         :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  will_perform :boolean          default(FALSE)
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
