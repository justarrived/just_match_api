# frozen_string_literal: true

class ApplicantWillPerformNotifier < BaseNotifier
  def self.call(job_user:, owner:)
    dispatch_user_email(job_user: job_user, owner: owner)
    dispatch_owner_email(job_user: job_user, owner: owner)
  end

  def self.dispatch_user_email(job_user:, owner:)
    user = job_user.user
    envelope = JobMailer.
               applicant_will_perform_job_info_email(job_user: job_user, owner: owner)
    dispatch(envelope, user: user, locale: user.locale)
  end

  def self.dispatch_owner_email(job_user:, owner:)
    envelope = JobMailer.
               applicant_will_perform_email(job_user: job_user, owner: owner)
    dispatch(envelope, user: owner, locale: owner.locale)
  end
end
