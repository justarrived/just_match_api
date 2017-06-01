# frozen_string_literal: true

module Sweepers
  class JobUserSweeper
    def self.applicant_confirmation_overdue(scope = JobUser)
      overdue_job_users = scope.applicant_confirmation_overdue.joins(job: [:owner])

      begin
        overdue_job_users.each do |job_user|
          job = job_user.job
          AcceptedApplicantConfirmationOverdueNotifier.call(
            job_user: job_user,
            owner: job.owner
          )
        end
      ensure
        overdue_job_users.update_all(accepted: false, accepted_at: nil) # rubocop:disable Rails/SkipsModelValidations, Metrics/LineLength
      end
      # NOTE: The returned JobUsers here will not have updated
      # accepted & accepted_at attriubutes, must be reloaded by the callee
      overdue_job_users
    end

    def self.update_job_filled(scope = Job)
      scope.unfilled.includes(:job_users).find_each(batch_size: 1000) do |job|
        confirmed_job_user = job.job_users.detect(&:will_perform)
        next if confirmed_job_user.nil?

        job.filled = true
        job.save!
      end
    end
  end
end
