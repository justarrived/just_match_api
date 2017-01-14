# frozen_string_literal: true
class InvoiceMissingCompanyFrilansFinansIdNotifier < BaseNotifier
  def self.call(ff_invoice:, job:)
    User.admins.each do |user|
      mailer_args = { user: user, ff_invoice: ff_invoice, job: job }
      notify(user: user) do
        AdminMailer.
          invoice_missing_company_frilans_finans_id_email(**mailer_args).
          deliver_later
      end
    end
  end
end
