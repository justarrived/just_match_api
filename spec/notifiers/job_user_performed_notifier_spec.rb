# frozen_string_literal: true
require 'rails_helper'

RSpec.describe JobUserPerformedNotifier, type: :mailer do
  let(:mailer) { Struct.new(:deliver_later).new(nil) }
  let(:job) { mock_model Job, owner: owner, accepted_applicant: user }
  let(:user) { FactoryGirl.build(:user) }
  let(:owner) { FactoryGirl.build(:user) }

  it 'must work' do
    allow(UserMailer).to receive(:job_user_performed_email).and_return(mailer)
    JobUserPerformedNotifier.call(job: job, user: user)
    mailer_args = { job: job, user: user, owner: job.owner }
    expect(UserMailer).to have_received(:job_user_performed_email).with(mailer_args)
  end
end
