# frozen_string_literal: true
class UserJobMatchNotifier < BaseNotifier
  def self.call(user:, job:, owner:)
    notify(user: user, locale: user.locale) do
      JobMailer.
        job_match_email(owner: owner, job: job, user: user).
        deliver_later
    end
  end
end
