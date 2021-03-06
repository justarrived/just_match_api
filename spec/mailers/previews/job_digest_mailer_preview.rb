# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/contact_mailer
class JobDigestMailerPreview < ActionMailer::Preview
  def digest_email
    uuid = SecureGenerator.uuid
    subscriber = DigestSubscriber.new(email: 'watman@example.com', uuid: uuid)
    JobDigestMailer.digest_email(
      jobs: Job.with_translations.last(15),
      job_digest: JobDigest.new(digest_subscriber_id: 67, subscriber: subscriber)
    )
  end

  def digest_created_email
    uuid = SecureGenerator.uuid
    subscriber = DigestSubscriber.new(email: 'watman@example.com', uuid: uuid)
    JobDigestMailer.digest_created_email(
      job_digest: JobDigest.new(digest_subscriber_id: 67, subscriber: subscriber)
    )
  end
end
