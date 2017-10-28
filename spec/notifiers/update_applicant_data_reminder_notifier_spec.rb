# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UpdateApplicantDataReminderNotifier, type: :mailer do
  let(:mailer) { Struct.new(:deliver_later).new(nil) }
  let(:job_user) { FactoryGirl.build(:job_user) }
  let(:skills) { FactoryGirl.build(:skill) }
  let(:languages) { FactoryGirl.build(:language) }
  let(:missing_cv) { false }

  it 'sends email' do
    allow(JobUserMailer).to receive(:update_data_reminder_email).and_return(mailer)
    mailer_args = {
      job_user: job_user,
      skills: skills,
      languages: languages,
      missing_cv: missing_cv
    }
    described_class.call(**mailer_args)
    expect(JobUserMailer).to have_received(:update_data_reminder_email).with(**mailer_args) # rubocop:disable Metrics/LineLength
  end
end
