# frozen_string_literal: true
class CreateJobUserAcceptService
  def self.call(job_user:)
    return job_user if job_user.accepted

    job = job_user.job
    job_user.accepted = true

    if job_user.save
      ApplicantAcceptedNotifier.call(job_user: job_user, owner: job.owner)
    end

    job_user
  end
end
