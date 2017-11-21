# frozen_string_literal: true

class JobUserMailer < ApplicationMailer
  default from: DEFAULT_SUPPORT_EMAIL

  def new_applicant_job_info_email(job_user:, skills:, languages:, occupations:, missing_cv: true) # rubocop:disable Metrics/LineLength
    user = job_user.user
    @user_name = user.first_name
    @job_name = job_user.job.name
    @missing_cv = missing_cv

    skill_names = skills.map(&:name)
    occupation_names = occupations.map(&:name)
    language_names = languages.map { |language| language.name_for(I18n.locale) }
    @competence_names = occupation_names + skill_names + language_names

    @user_edit_url = frontend_mail_url(
      :update_profile,
      utm_campaign: 'new_applicant_job_info'
    )

    subject = I18n.t('mailer.new_applicant_job_info.subject')
    mail(to: user.contact_email, subject: subject)
  end

  def update_data_reminder_email(job_user:, skills: [], languages: [], occupations: [], missing_cv: true) # rubocop:disable Metrics/LineLength
    utm_campaign = 'update_data_reminder'
    user = job_user.user
    @job = job_user.job

    skill_names = skills.map(&:name)
    occupation_names = occupations.map(&:name)
    language_names = languages.map { |language| language.name_for(I18n.locale) }
    @competence_names = occupation_names + skill_names + language_names

    @missing_cv = missing_cv
    @job_url = frontend_mail_url(:job, id: @job.id, utm_campaign: utm_campaign)
    @user_edit_url = frontend_mail_url(:update_profile, utm_campaign: utm_campaign) # rubocop:disable Metrics/LineLength

    subject = I18n.t('mailer.update_data_reminder.subject')
    mail(to: user.contact_email, subject: subject)
  end
end
