# frozen_string_literal: true
class AcceptedApplicantWithdrawnNotifier
  def self.call(job:, user:)
    owner = job.owner

    UserMailer.
      accepted_applicant_withdrawn_email(user: user, job: job, owner: owner).
      deliver_later
  end
end
