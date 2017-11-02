# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewApplicantNotifier, type: :mailer do
  let(:mailer) { Struct.new(:deliver_later).new(nil) }
  let(:job) { mock_model Job, owner: owner }
  let(:job_user) { mock_model JobUser, job: job, user: user }
  let(:user) { FactoryBot.build(:user) }
  let(:skills) { [FactoryBot.build(:skill)] }
  let(:languages) { [FactoryBot.build(:language)] }
  let(:owner) { FactoryBot.build(:user) }

  before(:each) do
    allow(JobMailer).to receive(:new_applicant_email).and_return(mailer)
    allow(JobUserMailer).to receive(:new_applicant_job_info_email).and_return(mailer)
  end

  it 'sends new_applicant_email mail' do
    NewApplicantNotifier.call(
      job_user: job_user,
      owner: owner,
      skills: skills,
      languages: languages,
      missing_cv: true
    )
    expect(JobMailer).to have_received(:new_applicant_email).with(job_user: job_user, owner: owner) # rubocop:disable Metrics/LineLength
  end

  it 'sends new_applicant_job_info_email mail' do
    mailer_args = {
      job_user: job_user,
      owner: owner,
      skills: skills,
      languages: languages,
      missing_cv: true
    }
    NewApplicantNotifier.call(**mailer_args)
    expected_args = {
      job_user: job_user, skills: skills, languages: languages, missing_cv: true
    }
    expect(JobUserMailer).to have_received(:new_applicant_job_info_email).with(expected_args) # rubocop:disable Metrics/LineLength
  end
end
