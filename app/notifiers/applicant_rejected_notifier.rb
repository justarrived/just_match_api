# frozen_string_literal: true

class ApplicantRejectedNotifier < BaseNotifier
  def self.call(job_user:)
    envelope = JobMailer.applicant_rejected_email(job_user: job_user)
    dispatch(envelope, user: job_user.user)
  end
end
