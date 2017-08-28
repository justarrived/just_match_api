# frozen_string_literal: true

class JobDigestMailer < ApplicationMailer
  def digest_email(jobs:, job_digest:)
    @jobs = jobs
    email = job_digest.email

    @more_jobs_url = frontend_mail_url(
      :jobs,
      utm_campaign: 'job_digest'
    )

    @unsubscribe_url = frontend_mail_url(
      :unsubscribe,
      subscriber_id: job_digest.digest_subscriber_id,
      utm_campaign: 'job_digest'
    )

    @has_coordinates = job_digest.coordinates?

    mail(to: email, subject: I18n.t('mailer.job_digest.subject'))
  end
end
