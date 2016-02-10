# frozen_string_literal: true
class NewApplicantNotifier
  def self.call(job_user:)
    job = job_user.job
    user = job_user.user
    owner = job.owner

    UserMailer.
      new_applicant_email(user: user, job: job, owner: owner).
      deliver_later
  end
end
