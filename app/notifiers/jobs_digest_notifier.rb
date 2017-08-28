# frozen_string_literal: true

class JobsDigestNotifier < BaseNotifier
  def self.call(jobs:, job_digest:)
    envelope = JobDigestMailer.digest_email(jobs: jobs, job_digest: job_digest)
    dispatch(envelope, locale: job_digest.locale)
  end
end
