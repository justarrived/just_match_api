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
      allow(AcceptedApplicantConfirmationOverdue).to receive(:call)
      record_count = subject.length
      expect(AcceptedApplicantConfirmationOverdue).to have_received(:call).
        exactly(record_count).times
    end
  end
end
