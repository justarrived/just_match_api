# frozen_string_literal: true
class FailedToActivateInvoiceNotifier < BaseNotifier
  def self.call(ff_invoice:)
    User.admins.each do |user|
      mailer_args = { user: user, ff_invoice: ff_invoice }
      notify(user: user) do
        AdminMailer.
          failed_to_activate_invoice_email(**mailer_args)
      end
    end
  end
end
