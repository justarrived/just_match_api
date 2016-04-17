# frozen_string_literal: true
class InvoiceMissingCompanyFrilansFinansIdNotifier < BaseNotifier
  def self.call(invoice:)
    User.admins.each do |user|
      next if ignored?(user)

      AdminMailer.
        invoice_missing_company_frilans_finans_id_email(user: user, invoice: invoice).
        deliver_later
    end
  end
end
