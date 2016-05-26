# frozen_string_literal: true
class AcceptedApplicantWithdrawnNotifier < BaseNotifier
  def self.call(job:, user:)
    owner = job.owner
    return if ignored?(owner)

    JobMailer.
      accepted_applicant_withdrawn_email(user: user, job: job, owner: owner).
      deliver_later
  end
end
