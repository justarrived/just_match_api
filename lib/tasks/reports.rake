# frozen_string_literal: true
require 'reports/invoices_report'

namespace :reports do
  namespace :finalcial do
    task montly: :environment do
      monthly_data = (6..10).map do |month_no|
        time_range = Date.new(2016, month_no, 1)..Date.new(2016, month_no + 1, 1)
        InvoicesReport.call(time_range)
      end

      job_rows_tempfile = Tempfile.new
      job_rows_csv = CSV.new(job_rows_tempfile)
      job_rows_csv << InvoicesReport::JOB_ROWS_HEADER
      begin
        monthly_data.map do |data|
          data[:rows].map { |row| job_rows_csv << row }
        end
      ensure
        job_rows_csv.flush
      end

      summary_rows_tempfile = Tempfile.new
      summary_rows_csv = CSV.new(summary_rows_tempfile)
      begin
        summary_rows_csv << monthly_data.first[:summary].keys.map(&:to_s)
        monthly_data.map do |data|
          summary_rows_csv << data[:summary].values
        end
      ensure
        summary_rows_csv.flush
      end

      ReportsMailer.send_monthly_report(
        email: User.admins.first.email,
        job_rows_path: job_rows_csv.path,
        summary_path: summary_rows_csv.path
      ).deliver_later
    end
  end
end
