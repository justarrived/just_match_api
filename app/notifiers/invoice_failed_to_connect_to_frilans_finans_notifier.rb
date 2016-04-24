# frozen_string_literal: true
class InvoiceFailedToConnectToFrilansFinansNotifier < BaseNotifier
  def self.call(invoice:)
    User.admins.each do |user|
      next if ignored?(user)

      mailer_args = { user: user, invoice: invoice }
      AdminMailer.
        invoice_failed_to_connect_to_frilans_finans_email(**mailer_args).
        deliver_later
    end
  end
end
