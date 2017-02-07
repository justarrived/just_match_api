# frozen_string_literal: true
class ApplicantWillPerformNotifier < BaseNotifier
  def self.call(job_user:, owner:)
    user_email(job_user: job_user, owner: owner)
    owner_email(job_user: job_user, owner: owner)

    rejected_emails(confirmed_job_user: job_user)
  end

  def self.rejected_emails(confirmed_job_user:)
    job_users = confirmed_job_user.job.job_users.includes(:user)

    job_users.each do |job_user|
      next if job_user == confirmed_job_user

      notify(user: job_user.user, name: :applicant_rejected) do
        JobMailer.
          applicant_rejected_email(job_user: job_user).
          deliver_later
      end
    end
  end

  def self.user_email(job_user:, owner:)
    user = job_user.user
    notify(user: user, locale: user.locale) do
      JobMailer.
        applicant_will_perform_job_info_email(job_user: job_user, owner: owner).
        deliver_later
    end
  end

  def self.owner_email(job_user:, owner:)
    notify(user: owner, locale: owner.locale) do
      JobMailer.
        applicant_will_perform_email(job_user: job_user, owner: owner)
    end
  end
end
