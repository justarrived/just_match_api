# frozen_string_literal: true
class JobTexter < ApplicationTexter
  def self.applicant_accepted_text(job_user:)
    user = job_user.user
    job = job_user.job
    @user_name = user.name
    @job_name = job.name

    @job_user_url = FrontendRouter.draw(:job_user, job_id: job.id)
    text(to: user.phone, template: 'job_texter/applicant_accepted_text')
  end
end
