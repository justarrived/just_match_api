# frozen_string_literal: true
class JobUserPerformedAcceptedNotifier < BaseNotifier
  def self.call(job:, user:)
    owner = job.owner
    return if ignored?(user)

    UserMailer.
      job_user_performed_accepted_email(user: user, job: job, owner: owner).
      deliver_later
  end
end
