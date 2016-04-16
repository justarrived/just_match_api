# frozen_string_literal: true
class CreateInvoiceService
  def self.create(job_user:, frilans_finans_attributes:)
    invoice = Invoice.new(job_user: job_user)
    invoice.validate

    unless invoice.valid?
      error_message = I18n.t('errors.invoice.frilans_finans_id')
      invoice.errors.add(:frilans_finans_id, error_message)
      return invoice
    end

    ff_invoice = FrilansFinansApi::Invoice.create(attributes: frilans_finans_attributes)
    id = ff_invoice.resource.id
    invoice.frilans_finans_id = id
    invoice.save!

    InvoiceCreatedNotifier.call(
      job: job_user.job,
      user: job_user.user
    )

    invoice
  end
end
