# frozen_string_literal: true
class ApplicantAcceptedNotifier < BaseNotifier
  def self.call(job:, user:)
    owner = job.owner
    return if ignored?(user)

    JobMailer.
      applicant_accepted_email(user: user, job: job, owner: owner).
      deliver_later
  end
end
