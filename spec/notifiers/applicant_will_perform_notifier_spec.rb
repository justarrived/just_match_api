# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicantWillPerformNotifier, type: :mailer do
  let(:mailer) { Struct.new(:deliver_later).new(nil) }
  let(:job) { mock_model Job, owner: owner, job_users: JobUser.none }
  let(:user) { FactoryBot.build(:user) }
  let(:owner) { FactoryBot.build(:user) }
  let(:job_user) { mock_model JobUser, user: user, job: job }

  it 'must work' do
    allow(JobMailer).to receive(:applicant_will_perform_email).and_return(mailer)
    allow(JobMailer).to receive(:applicant_will_perform_job_info_email).and_return(mailer)
    mailer_args = { job_user: job_user, owner: job.owner }
    described_class.call(**mailer_args)
    expect(JobMailer).to have_received(:applicant_will_perform_email).with(mailer_args)
    expect(JobMailer).to have_received(:applicant_will_perform_job_info_email).with(mailer_args) # rubocop:disable Metrics/LineLength
  end
end
