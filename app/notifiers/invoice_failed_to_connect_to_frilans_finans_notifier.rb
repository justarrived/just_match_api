# frozen_string_literal: true
class InvoiceFailedToConnectToFrilansFinansNotifier < BaseNotifier
  def self.call(ff_invoice:)
    User.super_admins.each do |user|
      mailer_args = { user: user, ff_invoice: ff_invoice }
      envelope = AdminMailer.
                 invoice_failed_to_connect_to_frilans_finans_email(**mailer_args)
      dispatch(envelope, user: user)
    end
  end
end
