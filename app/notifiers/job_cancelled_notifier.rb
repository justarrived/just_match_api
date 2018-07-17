# frozen_string_literal: true

class JobCancelledNotifier < BaseNotifier
  def self.call(job:)
    job_users = job.job_users.
                not_withdrawn.
                includes(:user)

    job_users.each do |job_user|
      user = job_user.user
      envelope = JobMailer.job_cancelled_email(user: user, job: job)
      dispatch(envelope, user: user, locale: user.locale)
    end
  end
end
