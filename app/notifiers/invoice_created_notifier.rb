# frozen_string_literal: true
class InvoiceCreatedNotifier < BaseNotifier
  def self.call(job:, user:)
    owner = job.owner
    return if ignored?(user)

    notify(locale: user.locale) do
      InvoiceMailer.
        invoice_created_email(user: user, job: job, owner: owner)
    end
  end
end
