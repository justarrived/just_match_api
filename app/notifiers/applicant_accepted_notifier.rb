# frozen_string_literal: true
class ApplicantAcceptedNotifier < BaseNotifier
  def self.call(job_user:, owner:)
    user = job_user.user
    return if ignored?(user)

    locale = user.locale
    notify(locale: locale) do
      JobTexter.applicant_accepted_text(job_user: job_user) if user.phone?
    end

    notify(locale: locale) do
      JobMailer.
        applicant_accepted_email(job_user: job_user, owner: owner)
    end
  end
end
