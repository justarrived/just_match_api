# frozen_string_literal: true

class InvoiceMissingCompanyFrilansFinansIdNotifier < BaseNotifier
  def self.call(ff_invoice:, job:)
    User.super_admins.each do |user|
      mailer_args = { user: user, ff_invoice: ff_invoice, job: job }
      envelope = AdminMailer.
                 invoice_missing_company_frilans_finans_id_email(**mailer_args)
      dispatch(envelope, user: user)
    end
  end
end
