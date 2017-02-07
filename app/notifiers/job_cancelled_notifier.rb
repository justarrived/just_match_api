# frozen_string_literal: true
class JobCancelledNotifier < BaseNotifier
  def self.call(job:)
    job.users.each do |user|
      notify(user: user, locale: user.locale) do
        JobMailer.
          job_cancelled_email(user: user, job: job)
      end
    end
  end
end
