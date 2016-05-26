# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ApplicantAcceptedNotifier, type: :mailer do
  let(:mailer) { Struct.new(:deliver_later).new(nil) }
  let(:job) { mock_model Job, owner: owner }
  let(:user) { FactoryGirl.build(:user) }
  let(:owner) { FactoryGirl.build(:user) }

  it 'must work' do
    allow(JobMailer).to receive(:applicant_accepted_email).and_return(mailer)
    ApplicantAcceptedNotifier.call(job: job, user: user)
    mailer_args = { job: job, user: user, owner: job.owner }
    expect(JobMailer).to have_received(:applicant_accepted_email).with(mailer_args)
  end
end
