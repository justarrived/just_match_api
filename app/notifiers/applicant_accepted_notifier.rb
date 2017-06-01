# frozen_string_literal: true

class ApplicantAcceptedNotifier < BaseNotifier
  def self.call(job_user:, owner:)
    user = job_user.user
    locale = user.locale

    if user.phone?
      envelope = JobTexter.applicant_accepted_text(job_user: job_user)
      dispatch(envelope, user: user, locale: locale)
    end

    envelope = JobMailer.
               applicant_accepted_email(job_user: job_user, owner: owner)

    dispatch(envelope, user: user, locale: locale)
  end
end
