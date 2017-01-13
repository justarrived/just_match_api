# frozen_string_literal: true
class AcceptedApplicantConfirmationOverdueNotifier < BaseNotifier
  def self.call(job_user:, owner:)
    return if ignored?(owner)

    notify(locale: owner.locale) do
      JobMailer.
        accepted_applicant_confirmation_overdue_email(job_user: job_user, owner: owner).
        deliver_later
    end
  end
end
