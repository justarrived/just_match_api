# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/job_mailer
class JobRequestMailerPreview < ActionMailer::Preview
  def new_job_request_email
    JobRequestMailer.new_job_request_email(
      job_request: JobRequest.last,
      recipient_email: 'admin@example.com'
    )
  end
end
