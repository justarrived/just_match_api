# frozen_string_literal: true
class JobCancelledNotifier < BaseNotifier
  def self.call(job:)
    job.users.each do |user|
      next if ignored?(user)

      notify(locale: user.locale) do
        JobMailer.
          job_cancelled_email(user: user, job: job)
      end
    end
  end
end
