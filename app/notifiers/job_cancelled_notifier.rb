# frozen_string_literal: true
class JobCancelledNotifier < BaseNotifier
  def self.call(job:)
    job.users.each do |user|
      next if ignored?(user)

      with_locale(user.locale) do
        JobMailer.
          job_cancelled_email(user: user, job: job).
          deliver_later
      end
    end
  end
end
