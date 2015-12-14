require 'rails_helper'

RSpec.describe JobUser, type: :model do
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
end
