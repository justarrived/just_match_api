# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ApplicantAcceptedNotifier, type: :mailer do
  before(:each) do
    mock = Struct.new(:deliver_later).new(nil)
    allow(JobMailer).to receive(:applicant_accepted_email).and_return(mock)
    allow(JobTexter).to receive(:applicant_accepted_text).and_return(mock)
  end

  let(:job) { mock_model Job, owner: owner }
  let(:user) { FactoryGirl.build(:user) }
  let(:owner) { FactoryGirl.build(:user) }
  let(:job_user) { mock_model JobUser, user: user, job: job }

  it 'calls job mailer' do
    mailer_args = { job_user: job_user, owner: job.owner }
    ApplicantAcceptedNotifier.call(**mailer_args)
    expect(JobMailer).to have_received(:applicant_accepted_email).with(mailer_args)
  end

  it 'calls job texter' do
    ApplicantAcceptedNotifier.call(job_user: job_user, owner: owner)
    expect(JobTexter).to have_received(:applicant_accepted_text).with(job_user: job_user)
  end
end
