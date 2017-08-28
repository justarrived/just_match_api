# frozen_string_literal: true

class DigestCreatedNotifier < BaseNotifier
  def self.call(job_digest:)
    envelope = JobDigestMailer.digest_created_email(job_digest: job_digest)
    dispatch(envelope, locale: job_digest.locale)
  end
end
