# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobUserPerformedNotifier, type: :mailer do
  let(:mailer) { Struct.new(:deliver_later).new(nil) }
  let(:job) { mock_model Job, owner: owner, accepted_applicant: user }
  let(:user) { FactoryGirl.build(:user) }
  let(:owner) { FactoryGirl.build(:user) }
  let(:job_user) { mock_model JobUser, job: job, user: user }

  it 'calls job mailer' do
    allow(JobMailer).to receive(:job_user_performed_email).and_return(mailer)
    mailer_args = { job_user: job_user, owner: job.owner }
    JobUserPerformedNotifier.call(**mailer_args)
    expect(JobMailer).to have_received(:job_user_performed_email).with(mailer_args)
  end
end
