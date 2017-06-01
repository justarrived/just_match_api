# frozen_string_literal: true

class JobRequestMailer < ApplicationMailer
  def new_job_request_email(job_request:, recipient_email:)
    subject = 'New job request!'

    @job_request_id = job_request.id
    @short_name = job_request.short_name
    @company_name = job_request.company_name
    @comment = job_request.comment
    @responsible = job_request.responsible
    @job_at_date = job_request.job_at_date
    @job_scope = job_request.job_scope
    @requirements = job_request.requirements
    @job_specification = job_request.job_specification

    mail(to: recipient_email, subject: subject)
  end
end
