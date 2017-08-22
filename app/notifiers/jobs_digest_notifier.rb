# frozen_string_literal: true

class JobsDigestNotifier < BaseNotifier
  def self.call(jobs:, email:, job_digest:, user: nil)
    envelope = JobDigestMailer.digest_email(
      email: email,
      jobs: jobs,
      job_digest: job_digest
    )
    dispatch(envelope, locale: user&.locale)
  end
end
