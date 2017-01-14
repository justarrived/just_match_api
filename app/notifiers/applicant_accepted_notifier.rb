# frozen_string_literal: true
class ApplicantAcceptedNotifier < BaseNotifier
  def self.call(job_user:, owner:)
    user = job_user.user
    locale = user.locale

    notify(user: user, locale: locale) do
      JobTexter.
        applicant_accepted_text(job_user: job_user).
        deliver_later
    end

    notify(user: user, locale: locale) do
      JobMailer.
        applicant_accepted_email(job_user: job_user, owner: owner).
        deliver_later
    end
  end
end
