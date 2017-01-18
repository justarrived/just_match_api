# frozen_string_literal: true
class UserJobMatchNotifier < BaseNotifier
  def self.call(user:, job:, owner:)
    return if ignored?(user)

    notify(locale: user.locale) do
      JobMailer.
        job_match_email(owner: owner, job: job, user: user)
    end
  end
end
