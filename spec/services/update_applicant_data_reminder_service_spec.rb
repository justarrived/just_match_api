# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UpdateApplicantDataReminderService do
  let(:job_user) { FactoryGirl.build(:job_user) }

  describe '::call' do
    it 'calls notifier' do
      allow(UpdateApplicantDataReminderNotifier).to receive(:call)
      UpdateApplicantDataReminderService.call(job_user: job_user)
      expect(UpdateApplicantDataReminderNotifier).to have_received(:call)
    end

    it 'does not call notifier if no data is missing' do
      allow(UpdateApplicantDataReminderNotifier).to receive(:call)
      allow_any_instance_of(Queries::MissingUserTraits).to receive(:cv?).and_return(false)
      UpdateApplicantDataReminderService.call(job_user: job_user)
      expect(UpdateApplicantDataReminderNotifier).not_to have_received(:call)
    end
  end
end
