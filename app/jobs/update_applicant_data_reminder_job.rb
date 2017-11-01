# frozen_string_literal: true

class UpdateApplicantDataReminderJob < ApplicationJob
  def perform(job_user:)
    UpdateApplicantDataReminderService.call(job_user: job_user)
  end
end
