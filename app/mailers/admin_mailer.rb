# frozen_string_literal: true
class AdminMailer < ApplicationMailer
  def invoice_missing_company_frilans_finans_id_email(user:, invoice:)
    @invoice = invoice
    @company = invoice.job.company
    @company_name = @company.name

    subject = I18n.t('admin.mailer.invoice_missing_company_frilans_finans_id.subject')
    mail(to: user.email, subject: subject)
  end
end
