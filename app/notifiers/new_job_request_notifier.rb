# frozen_string_literal: true
class NewJobRequestNotifier < BaseNotifier
  def self.call(job_request:)
    AppConfig.new_job_request_email_recipients.each do |email|
      notify do
        JobRequestMailer.
          new_job_request_email(job_request: job_request, recipient_email: email).
          deliver_now
      end
    end
  end
end
