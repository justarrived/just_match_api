# frozen_string_literal: true
class CreateFrilansFinansInvoiceService
  def self.create(ff_invoice:, pre_report: true, express_payment: false)
    job_user = ff_invoice.job_user
    job = job_user.job
    user = job_user.user

    if job.invoice_company_frilans_finans_id.nil?
      InvoiceMissingCompanyFrilansFinansIdNotifier.call(ff_invoice: ff_invoice, job: job)
      return ff_invoice
    end

    client = FrilansFinansApi.client_klass.new
    ff_invoice_attributes = FrilansFinansInvoiceAttributesService.call(
      client: client,
      user: user,
      job: job,
      pre_report: pre_report,
      express_payment: express_payment
    )
    # Idempotent invoice request http://developers.frilansfinans.xyz/#idempotent-requests
    ff_invoice_attributes[:remote_id] = ff_invoice.id
    ff_invoice_remote = FrilansFinansApi::Invoice.create(
      attributes: ff_invoice_attributes,
      client: client
    )
    return ff_invoice if ff_invoice_remote.error_status?

    frilans_finans_id = ff_invoice_remote.resource.id
    ff_invoice.frilans_finans_id = frilans_finans_id
    ff_invoice.express_payment = express_payment

    if frilans_finans_id.nil?
      InvoiceFailedToConnectToFrilansFinansNotifier.call(ff_invoice: ff_invoice)
    end

    ff_invoice.save!
    ff_invoice
  end
end
