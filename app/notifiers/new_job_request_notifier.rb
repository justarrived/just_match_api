# frozen_string_literal: true
class NewJobRequestNotifier < BaseNotifier
  def self.call(job_request:)
    AppConfig.new_job_request_email_recipients.each do |email|
      envelope = JobRequestMailer.
                 new_job_request_email(job_request: job_request, recipient_email: email)
      notify(envelope)
    end
  end
end
