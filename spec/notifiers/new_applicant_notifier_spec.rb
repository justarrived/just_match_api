# frozen_string_literal: true
require 'rails_helper'

RSpec.describe NewApplicantNotifier, type: :mailer do
  let(:mailer) { Struct.new(:deliver_later).new(nil) }
  let(:job) { mock_model Job, owner: owner }
  let(:job_user) { mock_model JobUser, job: job, user: user }
  let(:user) { FactoryGirl.build(:user) }
  let(:owner) { FactoryGirl.build(:user) }

  it 'calls job mailer' do
    allow(JobMailer).to receive(:new_applicant_email).and_return(mailer)
    mailer_args = { job_user: job_user, owner: owner }
    NewApplicantNotifier.call(**mailer_args)
    expect(JobMailer).to have_received(:new_applicant_email).with(mailer_args)
  end
end
