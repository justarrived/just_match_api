# frozen_string_literal: true
require 'rails_helper'

RSpec.describe AcceptedApplicantWithdrawnNotifier, type: :mailer do
  let(:mailer) { Struct.new(:deliver_later).new(nil) }
  let(:job) { mock_model Job, owner: nil }

  it 'must work' do
    allow(UserMailer).to receive(:accepted_applicant_withdrawn_email).and_return(mailer)
    described_class.call(job: job, user: nil)
    mailer_args = { job: job, user: nil, owner: job.owner }
    expect(UserMailer).to have_received(:accepted_applicant_withdrawn_email).
      with(mailer_args)
  end
end
