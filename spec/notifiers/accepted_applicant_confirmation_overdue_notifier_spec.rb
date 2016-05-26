# frozen_string_literal: true
require 'rails_helper'

RSpec.describe AcceptedApplicantConfirmationOverdueNotifier, type: :mailer do
  let(:mailer) { Struct.new(:deliver_later).new(nil) }
  let(:job) { mock_model Job, owner: owner }
  let(:user) { FactoryGirl.build(:user) }
  let(:owner) { FactoryGirl.build(:user) }

  it 'must work' do
    allow(JobMailer).to receive(:accepted_applicant_confirmation_overdue_email).
      and_return(mailer)
    described_class.call(job: job, user: user)
    mailer_args = { job: job, user: user, owner: job.owner }
    expect(JobMailer).to have_received(:accepted_applicant_confirmation_overdue_email).
      with(mailer_args)
  end
end
