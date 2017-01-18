# frozen_string_literal: true
class JobUserPerformedNotifier < BaseNotifier
  def self.call(job_user:, owner:)
    return if ignored?(owner)

    notify(locale: owner.locale) do
      JobMailer.
        job_user_performed_email(job_user: job_user, owner: owner)
    end
  end
end
