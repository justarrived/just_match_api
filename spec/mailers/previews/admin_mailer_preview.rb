# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/admin_mailer
class AdminMailerPreview < ActionMailer::Preview
  def invoice_missing_company_frilans_finans_id_email
    AdminMailer.invoice_missing_company_frilans_finans_id_email(
      user: User.first,
      ff_invoice: ff_invoice_mock,
      job: Job.first
    )
  end

  def invoice_failed_to_connect_to_frilans_finans_email
    AdminMailer.invoice_failed_to_connect_to_frilans_finans_email(
      user: User.first,
      ff_invoice: ff_invoice_mock
    )
  end

  def failed_to_activate_invoice_email
    AdminMailer.failed_to_activate_invoice_email(
      user: User.first,
      ff_invoice: ff_invoice_mock
    )
  end

  private

  def ff_invoice_mock
    FrilansFinansInvoice.new(id: 1)
  end
end
