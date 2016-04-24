# frozen_string_literal: true
class CreateInvoiceService
  def self.create(job_user:, frilans_finans_attributes:)
    job = job_user.job
    user = job_user.user
    invoice = Invoice.new(job_user: job_user)
    invoice.validate

    return invoice unless invoice.valid?

    if job.company.frilans_finans_id.nil?
      InvoiceMissingCompanyFrilansFinansIdNotifier.call(invoice: invoice, job: job)
    else
      # Build frilans finans invoice attributes
      attributes = frilans_finans_body(
        job: job,
        user: user,
        attributes: frilans_finans_attributes
      )

      ff_invoice = FrilansFinansApi::Invoice.create(attributes: attributes)
      frilans_finans_id = ff_invoice.resource.id
      invoice.frilans_finans_id = frilans_finans_id

      if frilans_finans_id.nil?
        InvoiceFailedToConnectToFrilansFinansNotifier.call(invoice: invoice)
      end
    end

    invoice.save!

    InvoiceCreatedNotifier.call(job: job, user: user)

    invoice
  end

  def self.frilans_finans_body(job:, user:, attributes:)
    attributes.merge(
      invoice: {
        currency_id: Currency.default_currency.try!(:frilans_finans_id),
        specification: "#{job.category.name} - #{job.name}",
        amount: job.amount,
        company_id: job.company.frilans_finans_id,
        tax_id: nil
      },
      workers: [{
        user_id: user.frilans_finans_id,
        travel: 0,
        vacation_pay: 0,
        itp: 0,
        express_payment: 0
      }],
      dates: [{
        date: job.job_date,
        hours: job.hours
      }]
    )
  end
end
