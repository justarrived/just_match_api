# frozen_string_literal: true
class ApplicantWillPerformNotifier < BaseNotifier
  def self.call(job_user:, owner:)
    return if ignored?(owner)

    notify(locale: owner.locale) do
      JobMailer.
        applicant_will_perform_email(job_user: job_user, owner: owner)
    end
  end
end
