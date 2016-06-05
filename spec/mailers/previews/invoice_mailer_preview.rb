# frozen_string_literal: true
# Preview all emails at http://localhost:3000/rails/mailers/invoice_mailer
class InvoiceMailerPreview < ActionMailer::Preview
  def invoice_created_email
    job = Job.first
    user = User.first
    owner = job.owner
    InvoiceMailer.invoice_created_email(user: user, job: job, owner: owner)
  end
end
