# frozen_string_literal: true
class JobUserPerformedAcceptedNotifier
  def self.call(job:, user:)
    owner = job.owner

    UserMailer.
      job_user_performed_accepted_email(user: user, job: job, owner: owner).
      deliver_later
  end
end
