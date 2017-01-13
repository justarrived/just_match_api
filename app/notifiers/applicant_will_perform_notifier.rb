# frozen_string_literal: true
class ApplicantWillPerformNotifier < BaseNotifier
  def self.call(job_user:, owner:)
    owner_email(job_user: job_user, owner: owner)

    rejected_emails(confirmed_job_user: job_user)
  end

  def self.rejected_emails(confirmed_job_user:)
    job_users = confirmed_job_user.job.job_users.includes(:user)

    job_users.each do |job_user|
      next if job_user == confirmed_job_user
      next if ignored?(job_user.user, :applicant_rejected)

      JobMailer.
        applicant_rejected_email(job_user: job_user).
        deliver_later
    end
  end

  def self.owner_email(job_user:, owner:)
    return if ignored?(owner)

    notify(locale: owner.locale) do
      JobMailer.
        applicant_will_perform_email(job_user: job_user, owner: owner).
        deliver_later
    end
  end
end
