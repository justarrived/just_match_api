# frozen_string_literal: true
class ApplicantAcceptedNotifier < BaseNotifier
  def self.call(job_user:, owner:)
    user = job_user.user
    locale = user.locale

    if user.phone?
      notify(user: user, locale: locale) do
        JobTexter.applicant_accepted_text(job_user: job_user)
      end
    end

    notify(user: user, locale: locale) do
      JobMailer.
        applicant_accepted_email(job_user: job_user, owner: owner)
    end
  end
end
