class UserJobMatchNotifier
  def self.call(user:, job:, owner:)
    UserMailer.
      job_match_email(owner: owner, job: job, user: user).
      deliver_later
  end
end
