# frozen_string_literal: true

class JobDigestMailer < ApplicationMailer
  def digest_email(jobs:, job_digest:)
    @utm_source = 'job_digest'
    @utm_campaign = 'digest_email'

    @jobs = jobs

    @more_jobs_url = frontend_mail_url(
      :jobs,
      utm_source: @utm_source,
      utm_campaign: @utm_campaign
    )

    @unsubscribe_url = frontend_mail_url(
      :unsubscribe,
      subscriber_id: job_digest.subscriber.uuid,
      utm_source: @utm_source,
      utm_campaign: @utm_campaign
    )

    @has_coordinates = job_digest.coordinates?

    @preheader = I18n.t('mailer.digest_email.preheader')

    mail(to: job_digest.email, subject: I18n.t('mailer.digest_email.subject'))
  end

  def digest_created_email(job_digest:)
    @unsubscribe_url = frontend_mail_url(
      :unsubscribe,
      subscriber_id: job_digest.subscriber.uuid,
      utm_campaign: 'digest_created'
    )

    @user_register_url = frontend_mail_url(
      :register,
      utm_campaign: 'digest_created'
    )

    @user = job_digest.user

    mail(to: job_digest.email, subject: I18n.t('mailer.digest_created.subject'))
  end
end
