# frozen_string_literal: true
class ApplicantWillPerformNotifier < BaseNotifier
  def self.call(job:, user:)
    owner = job.owner
    return if ignored?(owner)

    UserMailer.
      applicant_will_perform_email(user: user, job: job, owner: owner).
      deliver_later
  end
end
