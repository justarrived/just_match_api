# frozen_string_literal: true
class ApplicantWillPerformNotifier
  def self.call(job:, user:)
    owner = job.owner

    UserMailer.
      applicant_will_perform_email(user: user, job: job, owner: owner).
      deliver_later
  end
end
