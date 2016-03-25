# frozen_string_literal: true
require 'rails_helper'

RSpec.describe JobUserPerformedNotifier, type: :mailer do
  let(:mailer) { Struct.new(:deliver_later).new(nil) }
  let(:job) { mock_model Job, owner: nil, accepted_applicant: nil }

  it 'must work' do
    allow(UserMailer).to receive(:job_user_performed_email).and_return(mailer)
    JobUserPerformedNotifier.call(job: job, user: nil)
    mailer_args = { job: job, user: nil, owner: job.owner }
    expect(UserMailer).to have_received(:job_user_performed_email).with(mailer_args)
  end
end
