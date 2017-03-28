# frozen_string_literal: true
# Preview all emails at http://localhost:3000/rails/mailers/job_user_mailer
class JobUserMailerPreview < ActionMailer::Preview
  def new_applicant_job_info_email
    JobUserMailer.new_applicant_job_info_email(
      job_user: job_user, skills: skills, languages: languages
    )
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

  def skills
    @skills ||= Skill.last(2)
  end

  def languages
    @languages ||= Language.last(2)
  end
end
