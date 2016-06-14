# frozen_string_literal: true
class ApplicantAcceptedNotifier < BaseNotifier
  def self.call(job_user:, owner:)
    user = job_user.user
    return if ignored?(user)

    JobTexter.
      applicant_accepted_text(job_user: job_user).
      deliver_later

    JobMailer.
      applicant_accepted_email(job_user: job_user, owner: owner).
      deliver_later
  end
end
