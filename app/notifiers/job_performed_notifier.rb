class JobPerformedNotifier
  def self.call(job:)
    owner = job.owner
    user = job.job_user

    UserMailer.job_performed_email(user: user, job: job, owner: owner).deliver_later
  end
end
