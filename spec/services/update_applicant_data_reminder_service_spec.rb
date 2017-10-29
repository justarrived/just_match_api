# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UpdateApplicantDataReminderService do
  describe '::call' do
    it 'calls notifier' do
      job_user = FactoryGirl.build(:job_user)
      allow(UpdateApplicantDataReminderNotifier).to receive(:call)
      UpdateApplicantDataReminderService.call(job_user: job_user)
      expect(UpdateApplicantDataReminderNotifier).to have_received(:call)
    end

    it 'does not call notifier if no data is missing' do
      job_user = FactoryGirl.build(:job_user)
      allow(UpdateApplicantDataReminderNotifier).to receive(:call)
      allow_any_instance_of(Queries::MissingUserTraits).to receive(:cv?).and_return(false)
      UpdateApplicantDataReminderService.call(job_user: job_user)
      expect(UpdateApplicantDataReminderNotifier).not_to have_received(:call)
    end

    it 'does not call notifier if job user is rejected' do
      job_user = FactoryGirl.build(:job_user, rejected: true)
      allow(UpdateApplicantDataReminderNotifier).to receive(:call)
      UpdateApplicantDataReminderService.call(job_user: job_user)
      expect(UpdateApplicantDataReminderNotifier).not_to have_received(:call)
    end

    it 'does not call notifier if job user has withdrawn their application' do
      job_user = FactoryGirl.build(:job_user, application_withdrawn: true)
      allow(UpdateApplicantDataReminderNotifier).to receive(:call)
      UpdateApplicantDataReminderService.call(job_user: job_user)
      expect(UpdateApplicantDataReminderNotifier).not_to have_received(:call)
    end
  end
end
