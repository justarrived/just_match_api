# frozen_string_literal: true
class InvoiceFailedToConnectToFrilansFinansNotifier < BaseNotifier
  def self.call(ff_invoice:)
    User.admins.each do |user|
      mailer_args = { user: user, ff_invoice: ff_invoice }
      notify(user: user) do
        AdminMailer.
          invoice_failed_to_connect_to_frilans_finans_email(**mailer_args).
          deliver_later
      end
    end
  end
end
