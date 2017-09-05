# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DigestCreatedNotifier, type: :mailer do
  let(:mailer) { Struct.new(:deliver_later).new(nil) }
  let(:email) { 'watman@example.com' }
  let(:subscriber) { FactoryGirl.build_stubbed(:digest_subscriber, email: email) }
  let(:job_digest) { FactoryGirl.build_stubbed(:job_digest, subscriber: subscriber) }

  it 'must work' do
    allow(JobDigestMailer).to receive(:digest_created_email).and_return(mailer)
    described_class.call(job_digest: job_digest)
    expect(JobDigestMailer).to have_received(:digest_created_email).with(job_digest: job_digest) # rubocop:disable Metrics/LineLength
  end
end
