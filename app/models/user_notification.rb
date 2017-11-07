# frozen_string_literal: true

class UserNotification
  # Don't change the order or remove any items in the array,
  # only additions are allowed
  ALL = %w(
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

  def self.all
    ALL
  end
end
