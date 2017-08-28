# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobsDigestNotifier, type: :mailer do
  let(:mailer) { Struct.new(:deliver_later).new(nil) }
  let(:user) { mock_model User, locale: 'en' }
  let(:job) { FactoryGirl.build_stubbed(:job) }
  let(:email) { 'watman@example.com' }
  let(:subscriber) { FactoryGirl.build_stubbed(:digest_subscriber, email: email) }
  let(:job_digest) { FactoryGirl.build_stubbed(:job_digest, subscriber: subscriber) }

  it 'must work' do
    allow(JobDigestMailer).to receive(:digest_email).and_return(mailer)

    mailer_args = {
      jobs: [job],
      job_digest: job_digest
    }
    described_class.call(**mailer_args)
    expected_args = mailer_args.merge(email: email)
    expect(JobDigestMailer).to have_received(:digest_email).with(expected_args)
  end
end
