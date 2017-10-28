# frozen_string_literal: true

class JobUserMailer < ApplicationMailer
  default from: DEFAULT_SUPPORT_EMAIL

  def new_applicant_job_info_email(job_user:, skills:, languages:)
    user = job_user.user
    @user_name = user.first_name
    @job_name = job_user.job.name

    skill_names = skills.map(&:name)
    language_names = languages.map { |language| language.name_for(I18n.locale) }
    @competence_names = skill_names + language_names

    @user_edit_url = frontend_mail_url(
      :user_edit,
      id: user.id,
      utm_campaign: 'new_applicant_job_info'
    )

    subject = I18n.t('mailer.new_applicant_job_info.subject')
    mail(to: user.contact_email, subject: subject)
  end

  def update_data_reminder_email(job_user:)
    utm_campaign = 'update_data_reminder'
    missing_traits = Queries::MissingUserTraits
    user = job_user.user
    @job = job_user.job
    @missing_languages = missing_traits.languages(user: user, languages: @job.languages)
    @missing_skills = missing_traits.skills(user: user, skills: @job.skills)
    @missing_cv = missing_traits.cv?(user: user)
    @job_url = frontend_mail_url(:job, id: @job.id, utm_campaign: utm_campaign)
    @profile_update_url = frontend_mail_url(:user_edit, utm_campaign: utm_campaign)

    subject = I18n.t('mailer.update_data_reminder.subject')
    mail(to: user.contact_email, subject: subject)
  end
end
