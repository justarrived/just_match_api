# frozen_string_literal: true
class UserMailer < ApplicationMailer
  def welcome_email(user:)
    @user_name = user.name

    mail(to: user.email, subject: I18n.t('mailer.welcome.subject'))
  end

  def job_match_email(job:, user:, owner:)
    @user_name = user.name
    @owner_email = owner.email
    @job_name = job.name

    mail(to: user.email, subject: I18n.t('mailer.job_match.subject'))
  end

  def job_user_performed_email(user:, job:, owner:)
    @user_name = user.name
    @owner_name = owner.name
    @job_name = job.name
    @user_email = user.email

    subject = I18n.t('mailer.job_performed.subject')
    mail(to: owner.email, subject: subject)
  end

  def new_applicant_email(user:, job:, owner:)
    @user_name = user.name
    @user_email = user.email
    @user_phone = user.phone

    @job_name = job.name
    @owner_name = owner.name

    subject = I18n.t('mailer.new_applicant.subject')
    mail(to: owner.email, subject: subject)
  end

  def applicant_accepted_email(user:, job:, owner:)
    @user_name = user.name
    @owner_email = owner.email
    @job_name = job.name

    subject = I18n.t('mailer.applicant_accepted.subject')
    mail(to: user.email, subject: subject)
  end

  def applicant_will_perform_email(user:, job:, owner:)
    @user_name = user.name
    @job_name = job.name

    subject = I18n.t('mailer.applicant_will_perform.subject')
    mail(to: owner.email, subject: subject)
  end

  def accepted_applicant_withdrawn_email(user:, job:, owner:)
    @user_name = user.name
    @job_name = job.name

    subject = I18n.t('mailer.accepted_applicant_withdrawn.subject')
    mail(to: owner.email, subject: subject)
  end

  def accepted_applicant_confirmation_overdue_email(user:, job:, owner:)
    @user_name = user.name
    @job_name = job.name

    subject = I18n.t('mailer.accepted_applicant_confirmation_overdue.subject')
    mail(to: owner.email, subject: subject)
  end

  def reset_password_email(user:)
    @user_name = user.first_name
    token = user.one_time_token
    @reset_password_url = FrontendRouter.fetch(:reset_password, token: token)

    subject = I18n.t('mailer.reset_password.subject')
    mail(to: user.email, subject: subject)
  end

  def changed_password_email(user:)
    @user_name = user.first_name

    subject = I18n.t('mailer.changed_password.subject')
    mail(to: user.email, subject: subject)
  end
end
