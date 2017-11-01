# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobCancelledNotifier, type: :mailer do
  let(:mailer) { Struct.new(:deliver_later).new(nil) }
  let(:job) { FactoryBot.create(:job_with_users) }

  it 'sends notification to user' do
    user = job.users.first
    allow(JobMailer).to receive(:job_cancelled_email).
      and_return(mailer)

    described_class.call(job: job)

    mailer_args = { user: user, job: job }
    expect(JobMailer).to have_received(:job_cancelled_email).with(mailer_args)
  end

  it 'does not send notification to a user who has withdrawn their application' do
    job = FactoryBot.create(:job)
    FactoryBot.create(:job_user, job: job, application_withdrawn: true)

    allow(JobMailer).to receive(:job_cancelled_email).
      and_return(mailer)

    described_class.call(job: job)

    expect(JobMailer).not_to have_received(:job_cancelled_email)
  end
end
