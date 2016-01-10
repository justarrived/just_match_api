require 'rails_helper'

RSpec.describe NewApplicantNotifier, type: :mailer do
  let(:mailer) { Struct.new(:deliver_later).new(nil) }
  let(:job) { mock_model Job, owner: nil }
  let(:job_user) { mock_model JobUser, job: job, user: nil }

  it 'must work' do
    allow(UserMailer).to receive(:new_applicant_email).and_return(mailer)
    NewApplicantNotifier.call(job_user: job_user)
    expect(UserMailer).to have_received(:new_applicant_email)
  end
end
