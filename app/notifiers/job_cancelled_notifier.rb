# frozen_string_literal: true

class JobCancelledNotifier < BaseNotifier
  def self.call(job:)
    job.users.each do |user|
      envelope = JobMailer.job_cancelled_email(user: user, job: job)
      dispatch(envelope, user: user, locale: user.locale)
    end
  end
end
