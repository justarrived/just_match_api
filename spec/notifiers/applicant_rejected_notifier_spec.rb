# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicantRejectedNotifier, type: :mailer do
  let(:mailer) { Struct.new(:deliver_later).new(nil) }
  let(:job) { mock_model Job, job_users: JobUser.none }
  let(:user) { FactoryGirl.build(:user) }
  let(:job_user) { mock_model JobUser, user: user, job: job }

  it 'must work' do
    allow(JobMailer).to receive(:applicant_rejected_email).and_return(mailer)
    mailer_args = { job_user: job_user }
    described_class.call(**mailer_args)
    expect(JobMailer).to have_received(:applicant_rejected_email).with(mailer_args)
  end
end
