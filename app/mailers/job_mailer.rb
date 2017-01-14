# frozen_string_literal: true
class JobMailer < ApplicationMailer
  def job_match_email(job:, user:, owner:)
    @user_name = user.name
    @owner_email = owner.contact_email
    @job_name = job.name

    @job_url = FrontendRouter.draw(:job, id: job.id)

    mail(to: user.contact_email, subject: I18n.t('mailer.job_match.subject'))
  end

  def job_user_performed_email(job_user:, owner:)
    user = job_user.user
    job = job_user.job
    @user_name = user.name
    @owner_name = owner.name
    @job_name = job.name
    @user_email = user.contact_email

    @job_user_url = FrontendRouter.draw(
      :job_user_for_company,
      job_id: job.id,
      job_user_id: job_user.id
    )

    subject = I18n.t('mailer.job_performed.subject')
    mail(to: owner.contact_email, subject: subject)
  end

  def new_applicant_job_info_email(job_user:)
    user = job_user.user
    @user_name = user.first_name
    @job_name = job_user.job.name

    subject = I18n.t('mailer.new_applicant_job_info.subject')
    mail(to: user.contact_email, subject: subject)
  end

  def new_applicant_email(job_user:, owner:)
    user = job_user.user
    job = job_user.job
    @user_name = user.name
    @user_email = user.contact_email
    @user_phone = user.phone

    @job_name = job.name
    @owner_name = owner.name

    @job_user_url = FrontendRouter.draw(
      :job_user_for_company,
      job_id: job.id,
      job_user_id: job_user.id
    )

    subject = I18n.t('mailer.new_applicant.subject')
    mail(to: owner.contact_email, subject: subject)
  end

  def applicant_accepted_email(job_user:, owner:)
    user = job_user.user
    job = job_user.job
    @user_name = user.first_name
    @owner_email = owner.contact_email
    @job_name = job.name
    @job_start_date = TimeZone.cest_time(job.job_date)
    @job_end_date = TimeZone.cest_time(job.job_end_date)
    @total_hours = job.hours
    @hourly_gross_salary = job.hourly_gross_salary
    @total_salary = job.gross_amount
    @job_address = job.address
    @confirmation_time_hours = JobUser::MAX_CONFIRMATION_TIME_HOURS
    @google_calendar_url = job.google_calendar_template_url

    @job_user_url = FrontendRouter.draw(:job_user, job_id: job.id)

    subject = I18n.t('mailer.applicant_accepted.subject')
    mail(to: user.contact_email, subject: subject)
  end

  def applicant_will_perform_email(job_user:, owner:)
    user = job_user.user
    job = job_user.job
    @user_name = user.name
    @user_email = user.contact_email
    @user_phone = user.phone
    @job_name = job.name

    @job_user_url = FrontendRouter.draw(
      :job_user_for_company,
      job_id: job.id,
      job_user_id: job_user.id
    )

    subject = I18n.t('mailer.applicant_will_perform.subject')
    mail(to: owner.contact_email, subject: subject)
  end

  def applicant_will_perform_job_info_email(job_user:)
    user = job_user.user
    job = job_user.job
    contact = job.company_contact || job.owner
    ja_contact = job.just_arrived_contact

    @user_name = user.name
    @job_name = job.name
    @address = job.address
    @job_start_date = job.job_date
    @contact_person_name = contact&.name
    @contact_person_phone = contact&.phone
    @ja_contact_name = ja_contact&.name
    @ja_contact_phone = ja_contact&.phone
    @ja_contact_email = ja_contact&.email

    @job_user_url = FrontendRouter.draw(
      :job_user,
      job_id: job.id,
      job_user_id: job_user.id
    )

    subject = I18n.t('mailer.applicant_will_perform_job_info.subject')
    mail(to: user.contact_email, subject: subject)
  end

  def applicant_rejected_email(job_user:)
    user = job_user.user
    job = job_user.job
    @user_name = user.first_name
    @user_email = user.contact_email
    @job_name = job.name
    @support_email = AppConfig.support_email

    subject = I18n.t('mailer.applicant_rejected.subject')
    mail(to: @user_email, subject: subject)
  end

  def accepted_applicant_withdrawn_email(job_user:, owner:)
    user = job_user.user
    job = job_user.job
    @user_name = user.name
    @job_name = job.name

    subject = I18n.t('mailer.accepted_applicant_withdrawn.subject')
    mail(to: owner.contact_email, subject: subject)
  end

  def accepted_applicant_confirmation_overdue_email(job_user:, owner:)
    user = job_user.user
    job = job_user.job
    @user_name = user.name
    @job_name = job.name

    @job_users_url = FrontendRouter.draw(:job_users, job_id: job.id)

    subject = I18n.t('mailer.accepted_applicant_confirmation_overdue.subject')
    mail(to: owner.contact_email, subject: subject)
  end

  def job_cancelled_email(job:, user:)
    @job_name = job.name

    @jobs_url = FrontendRouter.draw(:jobs)

    subject = I18n.t('mailer.job_cancelled.subject')
    mail(to: user.contact_email, subject: subject)
  end

  def new_job_comment_email(comment:, job:)
    owner = job.owner
    @job_url = FrontendRouter.draw(:job, id: job.id)
    @comment_body = comment.original_body

    subject = I18n.t('mailer.new_job_comment.subject')
    mail(to: owner.contact_email, subject: subject)
  end
end
