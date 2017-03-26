# frozen_string_literal: true
class JobUserPerformedNotifier < BaseNotifier
  def self.call(job_user:, owner:)
    envelope = JobMailer.job_user_performed_email(job_user: job_user, owner: owner)
    notify(envelope, user: owner, locale: owner.locale)
  end
end
