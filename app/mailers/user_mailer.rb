class UserMailer < ApplicationMailer
  def job_match_email(job:, user:, owner:)
    @user_name = user.name
    @owner_email = owner.email
    @job_name = job.name

    mail(to: user.email, subject: 'Congrats, you have a new job match!')
  end

  def job_performed_accept_email(user:, job:, owner:)
    @user_name = user.name
    @owner_name = owner.name
    @job_name = job.name

    mail(to: owner.email, subject: 'Congrats, performed_accept a job!')
  end

  def new_applicant_mail(user:, job:, owner:)
    @user_name = user.name
    @user_email = user.email
    @user_phone = user.phone

    @job_name = job.name
    @owner_name = owner.name

    mail(to: owner.email, subject: 'Congrats, you have got a new applicant!')
  end

  def applicant_accepted_email(user:, job:, owner:)
    @user_name = user.name
    @owner_email = owner.email
    @job_name = job.name

    mail(to: user.email, subject: 'Congrats, got a job!')
  end
end
