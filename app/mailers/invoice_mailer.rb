# frozen_string_literal: true
class InvoiceMailer < ApplicationMailer
  def invoice_created_email(user:, job:, owner:)
    @user_name = user.name
    @owner_name = owner.name
    @owner_email = owner.contact_email
    @job_name = job.name
    @payslip_explain_url = AppConfig.payslip_explain_url

    subject = I18n.t('mailer.invoice_created.subject')
    mail(to: user.contact_email, subject: subject)
  end
end
