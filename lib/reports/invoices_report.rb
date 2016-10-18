# frozen_string_literal: true
module InvoicesReport
  JOB_ROWS_HEADER = %w(
    company job_name activated status payment_status approval_status
    user_name hours invoice_amount startdate enddate job_id
    invoice_id company_id frilans_finans_id
  ).freeze

  def self.call(range)
    jobs = Job.where(job_date: range).where(filled: true)

    hours_worked = 0
    invoice_sum = 0
    job_count = 0

    rows = []

    jobs.map do |job|
      job_user = job.accepted_job_user
      invoice = Invoice.find_by(job_user: job_user)
      next if invoice.nil?

      invoice_amount = job.invoice_amount
      rows << build_job_row(job, job_user, invoice, invoice_amount)

      job_count += 1
      hours_worked += job.hours
      invoice_sum += invoice_amount
    end

    {
      summary: {
        start: range.first.to_s,
        finish: range.last.to_s,
        hours: hours_worked,
        invoiced: invoice_sum.round(1),
        job_count: job_count
      },
      rows: rows
    }
  end

  def self.build_job_row(job, job_user, invoice, invoice_amount)
    company = job.company
    ff_invoice = invoice.frilans_finans_invoice

    frilans_finans_id = ff_invoice.frilans_finans_id
    ff_remote_data = remote_frilans_finans_data(frilans_finans_id)

    [
      company.name,
      job.name.delete(','),
      ff_invoice.activated,
      decorate_status(ff_remote_data['status']),
      decorate_payment_status(ff_remote_data['payment_status']),
      decorate_approval_status(ff_remote_data['approval_status']),
      job_user.user.name,
      job.hours.round(1),
      invoice_amount.round(1),
      job.job_date,
      job.job_end_date,
      job.id,
      invoice.id,
      company.id,
      frilans_finans_id
    ]
  end

  def self.remote_frilans_finans_data(ff_id)
    document = FrilansFinansApi::Invoice.show(id: ff_id)
    document.resource.attributes
  end

  def self.decorate_status(status_int)
    case status_int
    when 1  then 'Not paid'
    when 2  then 'Paid'
    when 3  then 'Credit invoice'
    when 4  then 'Credited'
    when 5  then 'Client loss'
    when 6  then 'Partly paid'
    when 7  then 'Saved'
    when 9  then 'Credit errand'
    when 10 then 'Dummy invoice'
    when 11 then 'ROT/RUT invoice'
    when 12 then 'ROT/RUT'
    when 13 then 'Skatteverket (Swedish Tax Agency)'
    else
      status_int
    end
  end

  def self.decorate_payment_status(status_int)
    case status_int
    when 1 then 'Not paid'
    when 2 then 'Paid'
    when 3 then 'Partly paid'
    when 4 then 'Started'
    else
      status_int
    end
  end

  def self.decorate_approval_status(status_int)
    case status_int
    when 1 then 'Waiting on approval'
    when 2 then 'Approved'
    when 3 then 'Not approved'
    when 4 then 'Waiting on payment'
    when 5 then 'Saved'
    else
      status_int
    end
  end
end
