# frozen_string_literal: true
class JobUserPerformedNotifier < BaseNotifier
  def self.call(job:, user:)
    owner = job.owner
    return if ignored?(owner)

    JobMailer.
      job_user_performed_email(user: user, job: job, owner: owner).
      deliver_later
  end
end
