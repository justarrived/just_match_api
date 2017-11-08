# frozen_string_literal: true

require 'spec_helper'

RSpec.describe UserNotification do
  let(:all_notifications) do
    %w(
      accepted_applicant_confirmation_overdue
      accepted_applicant_withdrawn
      applicant_accepted
      applicant_will_perform
      invoice_created
      job_user_performed
      job_cancelled
      new_applicant
      user_job_match
      new_chat_message
      new_job_comment
      applicant_rejected
      job_match
      new_applicant_job_info
      applicant_will_perform_job_info
      failed_to_activate_invoice
      update_data_reminder
    ).freeze
  end

  let(:candidate_notifications) do
    %w(
      applicant_accepted
      invoice_created
      job_cancelled
      user_job_match
      new_chat_message
      applicant_rejected
      job_match
      new_applicant_job_info
      applicant_will_perform_job_info
      update_data_reminder
    ).freeze
  end

  let(:company_notificaitons) do
    %w(
      accepted_applicant_confirmation_overdue
      accepted_applicant_withdrawn
      applicant_will_perform
      job_user_performed
      new_applicant
      user_job_match
      new_chat_message
      new_job_comment
      job_match
      failed_to_activate_invoice
    ).freeze
  end

  describe '::names' do
    it 'returns all notifications in the correct order' do
      # We must use #eq here, since the order of the array is signifcant
      # (ist used for a bitmask)
      expect(described_class.names).to eq(all_notifications)
    end

    it 'returns all candidate notifications in the right order' do
      expect(described_class.names(user_role: :candidate)).to eq(candidate_notifications)
    end

    it 'returns all company notifications in the right order' do
      expect(described_class.names(user_role: :company)).to eq(company_notificaitons)
    end

    it 'returns all admin notifications in the right order' do
      expect(described_class.names(user_role: :admin)).to eq(all_notifications)
    end

    it 'raises ArgumentError if unknown user role is passed' do
      expect do
        described_class.names(user_role: :watman)
      end.to raise_error(ArgumentError)
    end
  end
end
