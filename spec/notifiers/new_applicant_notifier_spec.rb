# frozen_string_literal: true
require 'rails_helper'

RSpec.describe NewApplicantNotifier, type: :mailer do
  let(:mailer) { Struct.new(:deliver_later).new(nil) }
  let(:job) { mock_model Job, owner: owner }
  let(:job_user) { mock_model JobUser, job: job, user: user }
  let(:user) { FactoryGirl.build(:user) }
  let(:owner) { FactoryGirl.build(:user) }

  it 'must work' do
    allow(JobMailer).to receive(:new_applicant_email).and_return(mailer)
    NewApplicantNotifier.call(job_user: job_user)
    mailer_args = { job: job, user: user, owner: job.owner }
    expect(JobMailer).to have_received(:new_applicant_email).with(mailer_args)
  end
end
