# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sweepers::JobUserSweeper do
  describe '#applicant_confirmation_overdue' do
    before(:each) do
      ju = FactoryGirl.create(:job_user, accepted: true)
      ju.accepted_at = 2.weeks.ago
      ju.save!
    end

    subject { described_class.applicant_confirmation_overdue(JobUser) }

    it 'finds all overdue job_users' do
      expect(subject.length).to eq(1)
    end

    it 'updates accepted attribute to false' do
      subject.each do |job_user|
        expect(job_user.reload.accepted).to eq(false)
      end
    end

    it 'updates accepted_at attribute to false' do
      subject.each do |job_user|
        expect(job_user.reload.accepted).to eq(false)
      end
    end

    it 'updates accepted_at attribute to false' do
      allow(AcceptedApplicantConfirmationOverdueNotifier).to receive(:call)
      record_count = subject.length
      expect(AcceptedApplicantConfirmationOverdueNotifier).to have_received(:call).
        exactly(record_count).times
    end
  end

  describe '#update_job_filled' do
    before(:each) do
      @job_user = FactoryGirl.create(:job_user, accepted: true, will_perform: true)
      @job_user.save!
    end

    subject { described_class.update_job_filled(Job) }

    it 'updates job#filled attribute to true' do
      subject
      expect(@job_user.job.reload.filled).to eq(true)
    end
  end
end
