# frozen_string_literal: true
class AcceptedApplicantWithdrawnNotifier < BaseNotifier
  def self.call(job_user:, owner:)
    return if ignored?(owner)

    JobMailer.
      accepted_applicant_withdrawn_email(job_user: job_user, owner: owner).
      deliver_later
  end
end
