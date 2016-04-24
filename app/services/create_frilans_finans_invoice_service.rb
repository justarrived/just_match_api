# frozen_string_literal: true
class CreateFrilansFinansInvoiceService
  def self.create(invoice:)
    job_user = invoice.job_user
    job = job_user.job
    user = job_user.user

    if job.company.frilans_finans_id.nil?
      InvoiceMissingCompanyFrilansFinansIdNotifier.call(invoice: invoice, job: job)
    else
      # Build frilans finans invoice attributes
      attributes = frilans_finans_body(job: job, user: user)

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

  def self.frilans_finans_body(job:, user:)
    {
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
      dates: calculate_dates(job)
    }
  end

  def self.calculate_dates(job)
    weekdays = DateSupport.weekdays_in(job.job_date, job.job_end_date)
    weekdays.map! do |date|
      {
        date: date,
        hours: job.hours / weekdays.length
      }
    end
  end
end
