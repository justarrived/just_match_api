# frozen_string_literal: true
require 'rails_helper'

RSpec.describe NewApplicantNotifier, type: :mailer do
  let(:mailer) { Struct.new(:deliver_later).new(nil) }
  let(:job) { mock_model Job, owner: owner }
  let(:job_user) { mock_model JobUser, job: job, user: user }
  let(:user) { FactoryGirl.build(:user) }
  let(:skills) { [FactoryGirl.build(:skill)] }
  let(:owner) { FactoryGirl.build(:user) }

  before(:each) do
    allow(JobMailer).to receive(:new_applicant_email).and_return(mailer)
    allow(JobMailer).to receive(:new_applicant_job_info_email).and_return(mailer)
  end

  it 'sends new_applicant_email mail' do
    mailer_args = { job_user: job_user, owner: owner, skills: skills }
    NewApplicantNotifier.call(**mailer_args)
    expect(JobMailer).to have_received(:new_applicant_email).with(mailer_args)
  end

  it 'sends new_applicant_job_info_email mail' do
    mailer_args = { job_user: job_user, owner: owner }
    NewApplicantNotifier.call(**mailer_args)
    expect(JobMailer).to have_received(:new_applicant_job_info_email).with(job_user: job_user) # rubocop:disable Metrics/LineLength
  end
end
