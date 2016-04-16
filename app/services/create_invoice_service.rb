# frozen_string_literal: true
class CreateInvoiceService
  def self.create(job_user:, frilans_finans_attributes:)
    invoice = Invoice.new(job_user: job_user)
    invoice.validate

    if invoice.valid?
      ff_invoice = FrilansFinansApi::Invoice.create(attributes: frilans_finans_attributes)
      invoice.frilans_finans_id = ff_invoice.resource.id
      invoice.save!

      InvoiceCreatedNotifier.call(
        job: job_user.job,
        user: job_user.user
      )
    end

    invoice
  end
end
