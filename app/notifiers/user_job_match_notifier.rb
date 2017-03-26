# frozen_string_literal: true
class UserJobMatchNotifier < BaseNotifier
  def self.call(user:, job:, owner:)
    envelope = JobMailer.job_match_email(owner: owner, job: job, user: user)
    notify(envelope, user: user, locale: user.locale)
  end
end
