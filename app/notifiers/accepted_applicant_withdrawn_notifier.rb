# frozen_string_literal: true
class AcceptedApplicantWithdrawnNotifier < BaseNotifier
  def self.call(job_user:, owner:)
    envelope = JobMailer.
               accepted_applicant_withdrawn_email(job_user: job_user, owner: owner)

    dispatch(envelope, user: owner, locale: owner.locale)
  end
end
