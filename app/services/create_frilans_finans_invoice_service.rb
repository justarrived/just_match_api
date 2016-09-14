# frozen_string_literal: true
class CreateFrilansFinansInvoiceService
  def self.create(ff_invoice:)
    job_user = ff_invoice.job_user
    job = job_user.job
    user = job_user.user

    if job.company.frilans_finans_id.nil?
      InvoiceMissingCompanyFrilansFinansIdNotifier.call(ff_invoice: ff_invoice, job: job)
      return ff_invoice
    end

    ff_invoice_remote = frilans_finans_invoice(user: user, job: job)
    return ff_invoice if ff_invoice_remote.error_status?

    frilans_finans_id = ff_invoice_remote.resource.id
    ff_invoice.frilans_finans_id = frilans_finans_id

    if frilans_finans_id.nil?
      InvoiceFailedToConnectToFrilansFinansNotifier.call(ff_invoice: ff_invoice)
    end

    ff_invoice.save!
    ff_invoice
  end

  def self.frilans_finans_invoice(user:, job:)
    client = FrilansFinansApi.client_klass.new
    tax = FrilansFinansApi::Tax.index(only_standard: true, client: client).resource

    # We need to update the users profession title to match the jobs,
    # in order to please Frilans Finans
    ff_user = FrilansFinansApi::User.update(
      id: user.frilans_finans_id!,
      attributes: { profession_title: job.category.name }
    )

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
