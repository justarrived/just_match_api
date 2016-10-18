# frozen_string_literal: true
class ReportsMailer < ApplicationMailer
  def send_monthly_report(email:, job_rows_path:, summary_path:)
    attachments['job_rows.csv'] = File.read(job_rows_path)
    attachments['summary.csv'] = File.read(summary_path)

    mail(to: email, subject: 'Montly reports', body: 'Please see attached CSV files.')
  end
end
