# frozen_string_literal: true
class InvoiceMissingCompanyFrilansFinansIdNotifier < BaseNotifier
  def self.call(invoice:, job:)
    User.admins.each do |user|
      next if ignored?(user)

      mailer_args = { user: user, invoice: invoice, job: job }
      AdminMailer.
        invoice_missing_company_frilans_finans_id_email(**mailer_args).
        deliver_later
    end
  end
end
