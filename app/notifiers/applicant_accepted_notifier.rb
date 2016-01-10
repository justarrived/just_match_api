class ApplicantAcceptedNotifier
  def self.call(job:, user:)
    owner = job.owner

    UserMailer.
      applicant_accepted_email(user: user, job: job, owner: owner).
      deliver_later
  end
end
