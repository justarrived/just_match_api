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

    client = FrilansFinansApi.client_klass.new
    tax = FrilansFinansApi::Tax.index(only_standard: true, client: client).resource

    ff_user = FrilansFinansApi::User.show(id: user.frilans_finans_id!)

    # Build frilans finans invoice attributes
    attributes = frilans_finans_body(job: job, user: user, tax: tax, ff_user: ff_user)

    ff_invoice = FrilansFinansApi::Invoice.create(
      attributes: attributes,
      client: client
    )
    frilans_finans_id = ff_invoice.resource.id
    invoice.frilans_finans_id = frilans_finans_id

    if frilans_finans_id.nil?
      InvoiceFailedToConnectToFrilansFinansNotifier.call(invoice: invoice)
    end

    invoice.save!

    InvoiceCreatedNotifier.call(job: job, user: user)

    invoice
  end

  def self.frilans_finans_body(job:, user:, tax:, ff_user:)
    {
      invoice: {
        invoiceuser: invoice_users(job: job, user: user, ff_user: ff_user),
        invoicedate: invoice_dates(job: job)
      }.merge!(invoice_data(job: job, user: user, tax: tax))
    }
  end

  def self.invoice_data(job:, user:, tax:)
    {
      currency_id: Currency.default_currency.try!(:frilans_finans_id),
      specification: "#{job.category.name} - #{job.name}",
      amount: job.amount,
      company_id: job.company.frilans_finans_id,
      tax_id: tax.id,
      user_id: user.frilans_finans_id
    }
  end

  def self.invoice_users(job:, user:, ff_user:)
    ff_user_attributes = ff_user.resource.attributes

    taxkey_id = ff_user_attributes['default_taxkey_id'] if ff_user.resource.attributes

    unless Rails.configuration.x.frilans_finans_default_taxkey_id.blank?
      taxkey_id = Rails.configuration.x.frilans_finans_default_taxkey_id
    end

    [{
      user_id: user.frilans_finans_id,
      total: job.amount,
      taxkey_id: taxkey_id,
      allowance: 0,
      travel: 0,
      vacation_pay: 0,
      itp: 0,
      express_payment: 0
    }]
  end

  def self.invoice_dates(job:)
    workdays = job.workdays
    return [] if workdays.length.zero? # TODO: Remove this line, its to battle bad data..
    hours_per_date = job.hours / workdays.length
    # Frilans Finans wants hours rounded to the closets half
    hours_per_date_rounded = (hours_per_date * 2).round.to_f / 2
    workdays.map do |date|
      {
        date: date,
        hours: hours_per_date_rounded
      }
    end
  end
end
