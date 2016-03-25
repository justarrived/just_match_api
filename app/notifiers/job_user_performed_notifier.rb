# frozen_string_literal: true
class JobUserPerformedNotifier
  def self.call(job:, user:)
    owner = job.owner

    UserMailer.
      job_user_performed_email(user: user, job: job, owner: owner).
      deliver_later
  end
end
