# frozen_string_literal: true

class CreateJobApplicationService
  def self.call(job_user:, attributes:)
    job_user.assign_attributes(attributes)
    job_user.application_withdrawn = false
    job_user.language = Language.find_by(id: attributes[:language_id])

    if job_user.save
      job_user.set_translation(attributes)

      NewApplicantNotifierJob.perform_later(job_user: job_user)
      UpdateApplicantDataReminderJob.set(wait: 3.days).perform_later(job_user: job_user)
    end

    job_user
  end
end
