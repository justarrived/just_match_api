# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ApplicantAcceptedNotifier, type: :mailer do
  let(:mailer) { Struct.new(:deliver_later).new(nil) }
  let(:job) { mock_model Job, owner: owner }
  let(:user) { FactoryGirl.build(:user) }
  let(:owner) { FactoryGirl.build(:user) }
  let(:job_user) { mock_model JobUser, user: user, job: job }

  it 'calls job mailer' do
    allow(JobMailer).to receive(:applicant_accepted_email).and_return(mailer)
    mailer_args = { job_user: job_user, owner: job.owner }
    ApplicantAcceptedNotifier.call(**mailer_args)
    expect(JobMailer).to have_received(:applicant_accepted_email).with(mailer_args)
  end
end
