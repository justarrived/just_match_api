# frozen_string_literal: true
require 'rails_helper'

RSpec.describe JobCancelledNotifier, type: :mailer do
  let(:mailer) { Struct.new(:deliver_later).new(nil) }
  let(:job) { FactoryGirl.create(:job_with_users) }

  it 'must work' do
    user = job.users.first
    allow(UserMailer).to receive(:job_cancelled_email).
      and_return(mailer)

    described_class.call(job: job)

    mailer_args = { user: user, job: job }
    expect(UserMailer).to have_received(:job_cancelled_email).with(mailer_args)
  end
end
