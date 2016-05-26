# frozen_string_literal: true
class NewApplicantNotifier < BaseNotifier
  def self.call(job_user:)
    job = job_user.job
    user = job_user.user
    owner = job.owner
    return if ignored?(owner)

    JobMailer.
      new_applicant_email(user: user, job: job, owner: owner).
      deliver_later
  end
end
