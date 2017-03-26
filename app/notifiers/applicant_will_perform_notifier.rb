# frozen_string_literal: true
class ApplicantWillPerformNotifier < BaseNotifier
  def self.call(job_user:, owner:)
    user_email(job_user: job_user, owner: owner)
    owner_email(job_user: job_user, owner: owner)

    rejected_emails(confirmed_job_user: job_user)
  end

  def self.rejected_emails(confirmed_job_user:)
    job_users = confirmed_job_user.job.job_users.unrejected.includes(:user)

    job_users.each do |job_user|
      next if job_user == confirmed_job_user

      envelope = JobMailer.
                 applicant_rejected_email(job_user: job_user)
      notify(envelope, user: job_user.user, name: :applicant_rejected)
    end
  end

  def self.user_email(job_user:, owner:)
    user = job_user.user
    envelope = JobMailer.
               applicant_will_perform_job_info_email(job_user: job_user, owner: owner)
    notify(envelope, user: user, locale: user.locale)
  end

  def self.owner_email(job_user:, owner:)
    envelope = JobMailer.
               applicant_will_perform_email(job_user: job_user, owner: owner)
    notify(envelope, user: owner, locale: owner.locale)
  end
end
