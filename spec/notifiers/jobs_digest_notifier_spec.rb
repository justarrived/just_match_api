# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobsDigestNotifier, type: :mailer do
  let(:mailer) { Struct.new(:deliver_later).new(nil) }
  let(:user) { mock_model User, locale: 'en' }
  let(:job) { FactoryGirl.build_stubbed(:job) }
  let(:job_digest) { FactoryGirl.build_stubbed(:job_digest) }

  it 'must work' do
    allow(JobDigestMailer).to receive(:digest_email).and_return(mailer)

    mailer_args = {
      email: 'watman@example.com',
      jobs: [job],
      job_digest: job_digest
    }
    described_class.call(**mailer_args.merge(user: user))
    expect(JobDigestMailer).to have_received(:digest_email).with(mailer_args)
  end
end
