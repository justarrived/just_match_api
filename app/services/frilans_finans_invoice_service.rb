# frozen_string_literal: true
class FrilansFinansInvoiceService
  def self.create(job_user:)
    invoice = Invoice.new(job_user: job_user)

    ff_invoice = FrilansFinansApi::Invoice.create(attributes: {})
    invoice.frilans_finans_id = ff_invoice.resource.id
    invoice.save
    invoice
  end
end
