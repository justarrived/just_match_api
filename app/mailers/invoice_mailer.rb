# frozen_string_literal: true
class InvoiceMailer < ApplicationMailer
  def invoice_created_email(user:, job:, owner:)
    @user_name = user.name
    @owner_name = owner.name
    @job_name = job.name

    subject = I18n.t('mailer.invoice_created.subject')
    mail(to: user.email, subject: subject)
  end
end
