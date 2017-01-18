# frozen_string_literal: true
class InvoiceFailedToConnectToFrilansFinansNotifier < BaseNotifier
  def self.call(ff_invoice:)
    User.admins.each do |user|
      next if ignored?(user)

      mailer_args = { user: user, ff_invoice: ff_invoice }
      notify do
        AdminMailer.
          invoice_failed_to_connect_to_frilans_finans_email(**mailer_args)
      end
    end
  end
end
