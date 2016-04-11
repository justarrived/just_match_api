# frozen_string_literal: true
require 'seeds/base_seed'

module Dev
  class InvoiceSeed < BaseSeed
    def self.call(job_users:)
      max_invoices = max_count_opt('MAX_INVOICES', 20)

      log_seed(Invoice) do
        max_invoices.times do
          job_user = job_users.sample
          job_user.job.tap do |job|
            job.job_date = 1.day.ago
            job.save(validate: false) # Saving jobs in the passed is otherwised validated
          end

          invoice = Invoice.find_or_initialize_by(job_user: job_user)
          invoice.frilans_finans_id = Faker::Number.between(1, 10_000_000)
          invoice.save!
        end
      end
    end
  end
end
