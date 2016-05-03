# frozen_string_literal: true
class CreateFrilansFinansInvoiceService
  def self.create(invoice:)
    job_user = invoice.job_user
    job = job_user.job
    user = job_user.user

    if job.company.frilans_finans_id.nil?
      InvoiceMissingCompanyFrilansFinansIdNotifier.call(invoice: invoice, job: job)
      return invoice
    end

    ff_invoice = frilans_finans_invoice(user: user, job: job)
    frilans_finans_id = ff_invoice.resource.id

    invoice.frilans_finans_id = frilans_finans_id

    if frilans_finans_id.nil?
      InvoiceFailedToConnectToFrilansFinansNotifier.call(invoice: invoice)
    end

    invoice.save!
    InvoiceCreatedNotifier.call(job: job, user: user)

    invoice
  end

  def self.frilans_finans_invoice(user:, job:)
    client = FrilansFinansApi.client_klass.new
    tax = FrilansFinansApi::Tax.index(only_standard: true, client: client).resource

    ff_user = FrilansFinansApi::User.show(id: user.frilans_finans_id!)

    # Build frilans finans invoice attributes
    attributes = FrilansFinans::InvoiceWrapper.attributes(
      job: job,
      user: user,
      tax: tax,
      ff_user: ff_user
    )

    FrilansFinansApi::Invoice.create(
      attributes: attributes,
      client: client
    )
  end
end
