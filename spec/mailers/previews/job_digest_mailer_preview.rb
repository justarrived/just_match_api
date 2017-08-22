# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/contact_mailer
class JobDigestMailerPreview < ActionMailer::Preview
  def digest_email
    I18n.locale = :sv
    JobDigestMailer.digest_email(
      email: 'watman@example.com',
      jobs: Job.with_translations.last(5),
      job_digest: JobDigest.new(job_digest_subscriber_id: 67)
    )
  end
end
