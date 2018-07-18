# frozen_string_literal: true

class SendApplicantRejectNotificationsService
  def self.call(signed_job_user)
    job_users = signed_job_user.job.
                job_users.
                long_list.
                includes(:user)

    job_users.each do |job_user|
      next if signed_job_user == job_user

      ApplicantRejectedNotifier.call(job_user: job_user)
    end
  end
end
