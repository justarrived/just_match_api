# frozen_string_literal: true

class UserNotification
  CANDIDATE = %w(
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

  COMPANY = %w(
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

  def self.names(user_role: nil)
    return ALL unless user_role
    role = user_role.to_s

    return COMPANY if role == 'company'
    return CANDIDATE if role == 'candidate'
    return ALL if role == 'admin'

    fail(ArgumentError, "unknown role #{user_role}")
  end
end
