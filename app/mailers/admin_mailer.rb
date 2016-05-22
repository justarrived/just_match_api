# frozen_string_literal: true
class AdminMailer < ApplicationMailer
  def invoice_missing_company_frilans_finans_id_email(user:, ff_invoice:, job:)
    @ff_invoice = ff_invoice
    @company = job.company
    @company_name = @company.name

    subject = I18n.t('admin.mailer.invoice_missing_company_frilans_finans_id.subject')
    mail(to: user.email, subject: subject)
  end

  def invoice_failed_to_connect_to_frilans_finans_email(user:, ff_invoice:)
    @ff_invoice = ff_invoice
    @ff_invoice_id = ff_invoice.id
    model_name = I18n.t('activerecord.models.frilans_finans_invoice')
    @invoice_link_name = "#{model_name} ##{@ff_invoice_id}"

    subject = I18n.t('admin.mailer.invoice_failed_to_connect_to_frilans_finans.subject')
    mail(to: user.email, subject: subject)
  end
end
