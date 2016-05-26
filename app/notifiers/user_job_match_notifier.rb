# frozen_string_literal: true
class UserJobMatchNotifier < BaseNotifier
  def self.call(user:, job:, owner:)
    return if ignored?(user)

    JobMailer.
      job_match_email(owner: owner, job: job, user: user).
      deliver_later
  end
end
