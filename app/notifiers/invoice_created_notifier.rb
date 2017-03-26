# frozen_string_literal: true
class InvoiceCreatedNotifier < BaseNotifier
  def self.call(job:, user:)
    owner = job.owner

    envelope = InvoiceMailer.invoice_created_email(user: user, job: job, owner: owner)
    notify(envelope, user: user, locale: user.locale)
  end
end
