# frozen_string_literal: true
class AcceptedApplicantConfirmationOverdue
  def self.call(job:, user:)
    owner = job.owner

    UserMailer.
      accepted_applicant_confirmation_overdue_email(user: user, job: job, owner: owner).
      deliver_later
  end
end
