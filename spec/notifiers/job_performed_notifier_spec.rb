require 'rails_helper'

RSpec.describe JobPerformedNotifier, type: :mailer do
  let(:mailer) { Struct.new(:deliver_later).new(nil) }
  let(:job) { mock_model Job, owner: nil, accepted_applicant: nil }

  it 'must work' do
    allow(UserMailer).to receive(:job_performed_email).and_return(mailer)
    JobPerformedNotifier.call(job: job)
    expect(UserMailer).to have_received(:job_performed_email)
  end
end
