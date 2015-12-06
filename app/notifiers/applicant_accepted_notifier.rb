class ApplicantAcceptedNotifier
  def self.call(job_user:)
    job = job_user.job
    owner = job_user.job.owner
    user = job_user.user

    UserMailer.applicant_accepted_email(user: user, job: job, owner: owner).deliver_later
  end
end
