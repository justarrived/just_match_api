# frozen_string_literal: true
class CreateInvoiceService
  def self.create(job_user:, frilans_finans_attributes:)
    job = job_user.job
    user = job_user.user
    invoice = Invoice.new(job_user: job_user)
    invoice.validate

    return invoice unless invoice.valid?

    admin_notify_klass = NilNotifier
    admin_notify_args = {}
    if job.company.frilans_finans_id.nil?
      admin_notify_klass = InvoiceMissingCompanyFrilansFinansIdNotifier
      admin_notify_args = { invoice: invoice, job: job }
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
        admin_notify_klass = InvoiceFailedToConnectToFrilansFinansNotifier
        admin_notify_args = { invoice: invoice }
      end
    end

    invoice.save!

    admin_notify_klass.call(**admin_notify_args)
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
