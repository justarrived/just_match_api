# frozen_string_literal: true
class FailedToActivateInvoiceNotifier < BaseNotifier
  def self.call(ff_invoice:)
    User.super_admins.each do |user|
      mailer_args = { user: user, ff_invoice: ff_invoice }
      envelope = AdminMailer.failed_to_activate_invoice_email(**mailer_args)
      dispatch(envelope, user: user)
    end
  end
end
