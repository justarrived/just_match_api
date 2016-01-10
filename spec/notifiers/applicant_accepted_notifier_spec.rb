require 'rails_helper'

RSpec.describe ApplicantAcceptedNotifier, type: :mailer do
  let(:mailer) { Struct.new(:deliver_later).new(nil) }
  let(:job) { mock_model Job, owner: nil }

  it 'must work' do
    allow(UserMailer).to receive(:applicant_accepted_email).and_return(mailer)
    ApplicantAcceptedNotifier.call(job: job, user: nil)
    expect(UserMailer).to have_received(:applicant_accepted_email)
  end
end
