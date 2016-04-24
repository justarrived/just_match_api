# frozen_string_literal: true
class AdminMailer < ApplicationMailer
  def invoice_missing_company_frilans_finans_id_email(user:, invoice:, job:)
    @invoice = invoice
    @company = job.company
    @company_name = @company.name

    subject = I18n.t('admin.mailer.invoice_missing_company_frilans_finans_id.subject')
    mail(to: user.email, subject: subject)
  end

  def invoice_failed_to_connect_to_frilans_finans_email(user:, invoice:)
    @invoice = invoice
    @invoice_id = invoice.id
    @invoice_link_name = "#{I18n.t('activerecord.models.invoice')} ##{@invoice_id}"

    subject = I18n.t('admin.mailer.invoice_failed_to_connect_to_frilans_finans.subject')
    mail(to: user.email, subject: subject)
  end
end
