# frozen_string_literal: true
# Preview all emails at http://localhost:3000/rails/mailers/job_mailer
class JobMailerPreview < ActionMailer::Preview
  def job_match_email
    JobMailer.job_match_email(job: job, user: user, owner: owner)
  end

  def job_user_performed_email
    JobMailer.job_user_performed_email(job_user: job_user, owner: owner)
  end

  def new_applicant_email
    JobMailer.new_applicant_email(job_user: job_user, owner: owner)
  end

  def new_applicant_job_info_email
    JobMailer.new_applicant_job_info_email(job_user: job_user)
  end

  def applicant_accepted_email
    JobMailer.applicant_accepted_email(job_user: job_user, owner: owner)
  end

  def applicant_will_perform_email
    JobMailer.applicant_will_perform_email(job_user: job_user, owner: owner)
  end

  def applicant_will_perform_job_info_email
    JobMailer.applicant_will_perform_job_info_email(job_user: job_user, owner: owner)
  end

  def applicant_rejected_email
    JobMailer.applicant_rejected_email(job_user: job_user)
  end

  def accepted_applicant_withdrawn_email
    JobMailer.accepted_applicant_withdrawn_email(job_user: job_user, owner: owner)
  end

  def accepted_applicant_confirmation_overdue_email
    JobMailer.accepted_applicant_confirmation_overdue_email(
      job_user: job_user,
      owner: owner
    )
  end

  def job_cancelled_email
    JobMailer.job_cancelled_email(job: job, user: user)
  end

  private

  def job
    job_user.job
  end

  def job_user
    @job_user ||= JobUser.first
  end

  def user
    job_user.user
  end

  def owner
    job.owner
  end
end
