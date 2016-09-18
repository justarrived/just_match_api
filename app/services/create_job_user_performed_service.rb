# frozen_string_literal: true
class CreateJobUserPerformedService
  def self.call(job_user:)
    return job_user if job_user.performed

    job = job_user.job
    job_user.performed = true

    if job_user.save
      JobUserPerformedNotifier.call(job_user: job_user, owner: job.owner)
    end

    job_user
  end
end
